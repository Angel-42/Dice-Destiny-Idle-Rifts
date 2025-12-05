import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../l10n/app_localizations.dart';
import '../models/map_data.dart';
import '../models/character.dart';
import '../models/persona.dart';
import '../models/skill.dart';
import '../models/campaign_data.dart';
import '../models/dice.dart';
import '../widgets/tactical_map_widget.dart';
import '../widgets/character_detail_popup.dart';
import '../widgets/character_compact_view.dart';
import '../widgets/level_up_animation.dart';
import '../widgets/icon_display.dart';
import '../widgets/dice_animation_widget.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/phase_transition_overlay.dart';
import '../screens/combat_animation_screen.dart';
import '../services/game_data_service.dart';
import '../data/enemy_database.dart';

/// Écran de campagne avec map tactique et déplacement
class CampaignScreen extends StatefulWidget {
  final List<Character> team;
  final CampaignStage? stage; // Stage de campagne (null = mode test)

  const CampaignScreen({
    super.key,
    required this.team,
    this.stage,
  });

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  late TacticalMapData mapData;
  late List<UnitPosition> units;
  late Map<String, Character> charactersMap;
  UnitPosition? selectedUnit;
  Set<String> highlightedTiles = {}; // Cases de mouvement (bleues)
  Set<String> attackableTiles = {}; // Cases d'attaque (rouges)
  
  // Système de tours
  List<String> _allyTurnOrder = []; // Ordre des tours alliés (triés par Speed)
  List<String> _enemyTurnOrder = []; // Ordre des tours ennemis (triés par Speed)
  int _currentTurnIndex = 0;
  bool _isPlayerPhase = true; // true = phase alliés, false = phase ennemis
  Set<String> _unitsWhoActed = {}; // Unités qui ont déjà agi ce cycle/phase
  
  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    mapData = TacticalMapData.createTestMap();

    final team = widget.team;
    final baseY = mapData.height - 2;
    final startX = 1;
    units = [];
    charactersMap = {};

    for (var i = 0; i < team.length && i < 4; i++) {
      final c = team[i];
      charactersMap[c.id] = c;
      units.add(UnitPosition(
        unitId: c.id,
        x: startX + i,
        y: baseY,
        name: c.name,
        color: Color(c.appearance.colorValue),
        isPlayer: true,
        pixelSprite: c.appearance.pixel,
      ));
    }

    final enemies = [
      EnemyDatabase.createEnemy('wolf', level: 1),
      EnemyDatabase.createEnemy('wolf', level: 1),
    ];

    for (final enemy in enemies) {
      charactersMap[enemy.id] = enemy;
    }

    units.addAll([
      UnitPosition(
        unitId: enemies[0].id,
        x: 5,
        y: 2,
        name: enemies[0].name,
        color: Color(enemies[0].appearance.colorValue),
        isPlayer: false,
        pixelSprite: enemies[0].appearance.pixel,
      ),
      UnitPosition(
        unitId: enemies[1].id,
        x: 6,
        y: 3,
        name: enemies[1].name,
        color: Color(enemies[1].appearance.colorValue),
        isPlayer: false,
        pixelSprite: enemies[1].appearance.pixel,
      ),
    ]);
    
    // Initialiser l'ordre des tours
    _initializeTurnOrder();
  }
  
  /// Initialise l'ordre des tours basé sur la vitesse (Speed)
  void _initializeTurnOrder() {
    // Séparer alliés et ennemis
    final allies = units.where((u) => u.isPlayer).toList();
    final enemies = units.where((u) => !u.isPlayer).toList();
    
    // Trier par vitesse (du plus rapide au plus lent)
    allies.sort((a, b) {
      final charA = charactersMap[a.unitId]!;
      final charB = charactersMap[b.unitId]!;
      return charB.totalSpeed.compareTo(charA.totalSpeed); // Ordre décroissant
    });
    
    enemies.sort((a, b) {
      final charA = charactersMap[a.unitId]!;
      final charB = charactersMap[b.unitId]!;
      return charB.totalSpeed.compareTo(charA.totalSpeed);
    });
    
    // Stocker les ordres séparément
    _allyTurnOrder = allies.map((u) => u.unitId).toList();
    _enemyTurnOrder = enemies.map((u) => u.unitId).toList();
    
    _currentTurnIndex = 0;
    _isPlayerPhase = true;
    _unitsWhoActed.clear();
    
    // Démarrer la phase alliés avec message après le build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      PhaseTransitionOverlay.show(
        context: context,
        message: 'PLAYER PHASE',
        color: Colors.blue,
        duration: const Duration(milliseconds: 1500),
      );
      
      // Sélectionner automatiquement le premier allié après l'animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_allyTurnOrder.isNotEmpty && mounted) {
          _startUnitTurn(_allyTurnOrder[_currentTurnIndex]);
        }
      });
    });
  }
  
  /// Démarre le tour d'une unité
  void _startUnitTurn(String unitId) {
    final unit = units.firstWhere((u) => u.unitId == unitId);
    final character = charactersMap[unitId]!;
    
    setState(() {
      selectedUnit = unit;
      _highlightMoveAndAttackOptions(unit, character);
    });
  }
  
  /// Termine le tour de l'unité courante et passe à la suivante
  void _endCurrentUnitTurn() {
    final currentOrder = _isPlayerPhase ? _allyTurnOrder : _enemyTurnOrder;
    if (_currentTurnIndex >= currentOrder.length) return;
    
    final currentUnitId = currentOrder[_currentTurnIndex];
    _unitsWhoActed.add(currentUnitId);
    
    setState(() {
      selectedUnit = null;
      highlightedTiles.clear();
      attackableTiles.clear();
    });
    
    // Passer à l'unité suivante
    _nextTurn();
  }
  
  /// Passe au tour suivant
  void _nextTurn() {
    _currentTurnIndex++;
    
    final currentOrder = _isPlayerPhase ? _allyTurnOrder : _enemyTurnOrder;
    
    // Si on a terminé tous les tours de la phase actuelle
    if (_currentTurnIndex >= currentOrder.length) {
      _startNewPhase();
      return;
    }
    
    // Démarrer le tour de l'unité suivante
    _startUnitTurn(currentOrder[_currentTurnIndex]);
  }
  
  /// Démarre une nouvelle phase ou un nouveau cycle
  void _startNewPhase() {
    if (_isPlayerPhase) {
      // Fin de la phase alliés -> Passer à la phase ennemie
      _isPlayerPhase = false;
      _currentTurnIndex = 0;
      _unitsWhoActed.clear();
      
      PhaseTransitionOverlay.show(
        context: context,
        message: 'ENEMY PHASE',
        color: Colors.red,
        duration: const Duration(milliseconds: 1500),
      );
      
      // Démarrer le premier tour ennemi après l'animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_enemyTurnOrder.isNotEmpty && mounted) {
          _startUnitTurn(_enemyTurnOrder[_currentTurnIndex]);
        }
      });
    } else {
      // Fin de la phase ennemie -> Nouveau cycle, retour à la phase alliés
      _isPlayerPhase = true;
      _currentTurnIndex = 0;
      _unitsWhoActed.clear();
      
      PhaseTransitionOverlay.show(
        context: context,
        message: 'PLAYER PHASE',
        color: Colors.blue,
        duration: const Duration(milliseconds: 1500),
      );
      
      // Démarrer le premier tour allié après l'animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_allyTurnOrder.isNotEmpty && mounted) {
          _startUnitTurn(_allyTurnOrder[_currentTurnIndex]);
        }
      });
    }
  }
  


  void _onUnitTap(UnitPosition unit) {
    final character = charactersMap[unit.unitId];
    if (character == null) return;

    if (!unit.isPlayer) {
      // Afficher l'ennemi dans le header (comme pour les alliés)
      // Si on a une unité sélectionnée et que l'ennemi est à portée, on peut attaquer
      if (selectedUnit != null && selectedUnit!.isPlayer) {
        final distance = _calculateDistance(selectedUnit!.x, selectedUnit!.y, unit.x, unit.y);
        final selectedChar = charactersMap[selectedUnit!.unitId]!;
        final range = selectedChar.stats.range;
        
        if (distance <= range) {
          // Attaquer directement
          _startCombat(selectedChar, character, selectedUnit!, unit);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context)!.targetOutOfRange(distance, range)),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
      return;
    }

    // Pour les alliés: sélection/désélection
    if (unit.isPlayer) {
      setState(() {
        if (selectedUnit?.unitId == unit.unitId) {
          // Désélectionner
          selectedUnit = null;
          highlightedTiles.clear();
          attackableTiles.clear();
        } else {
          selectedUnit = unit;
          _highlightMoveAndAttackOptions(unit, character);
        }
      });
    }
  }



  int _calculateDistance(int x1, int y1, int x2, int y2) {
    return (x1 - x2).abs() + (y1 - y2).abs(); // Distance de Manhattan
  }

  Future<void> _startCombat(Character attacker, Character defender, 
      UnitPosition attackerUnit, UnitPosition defenderUnit) async {
    // Calculer la distance entre l'attaquant et le défenseur
    final distance = _calculateDistance(
      attackerUnit.x, attackerUnit.y, 
      defenderUnit.x, defenderUnit.y
    );
    
    // Obtenir la portée d'attaque du défenseur
    final defenderRange = defender.weapon?.attackRange ?? 1;
    
    // Vérifier si le défenseur peut riposter (il doit avoir la portée pour atteindre l'attaquant)
    final canDefenderCounter = distance <= defenderRange;
    
    // Vérifier si le personnage a une compétence active
    final activeSkill = attacker.equippedSkills
        .where((s) => s.type == SkillType.active)
        .firstOrNull;
    
    Skill? selectedSkill;
    
    // Si compétence active disponible, demander le choix
    if (activeSkill != null && attackerUnit.isPlayer) {
      selectedSkill = await _showAttackChoiceDialog(attacker, activeSkill);
      // Si l'utilisateur annule, on annule le combat
      if (selectedSkill == null && !mounted) return;
    }
    
    // Ouvrir la scène de combat animée
    final result = await Navigator.push<CombatResult>(
      context,
      MaterialPageRoute(
        builder: (context) => CombatAnimationScreen(
          attacker: attacker,
          defender: defender,
          attackerSkill: selectedSkill,
          canDefenderCounter: canDefenderCounter, // Passer l'info au combat
          onCombatEnd: (result) {
            Navigator.pop(context, result);
          },
        ),
      ),
    );

    if (result == null || !mounted) return;

    // Ajouter l'XP au personnage attaquant
    if (attackerUnit.isPlayer) {
      debugPrint('🎯 XP avant combat: ${attacker.xp}');
      debugPrint('💫 XP gagné: ${result.xpGained}');
      
      attacker.xp += result.xpGained;
      debugPrint('📊 XP après combat: ${attacker.xp}');
      
      // Vérifier si level up
      final xpNeeded = attacker.xpForNextLevel;
      debugPrint('🎓 XP nécessaire pour level ${attacker.level + 1}: $xpNeeded');
      
      if (attacker.xp >= xpNeeded) {
        debugPrint('⬆️ LEVEL UP! ${attacker.level} -> ${attacker.level + 1}');
        attacker.xp = (attacker.xp - xpNeeded).toInt();
        attacker.level += 1;
        
        // Calculer les augmentations de stats
        final statIncreases = _calculateStatIncreases(attacker);
        debugPrint('📈 Augmentations de stats: $statIncreases');
        
        // Appliquer les augmentations
        attacker.stats.maxHp = attacker.stats.maxHp + statIncreases['HP']!;
        attacker.stats.attack = attacker.stats.attack + statIncreases['ATK']!;
        attacker.stats.defense = attacker.stats.defense + statIncreases['DEF']!;
        attacker.stats.speed = attacker.stats.speed + statIncreases['SPD']!;
        attacker.stats.magic = attacker.stats.magic + statIncreases['MAG']!;
        attacker.stats.luck = attacker.stats.luck + statIncreases['LCK']!;
        
        // Restaurer HP au max
        attacker.currentHp = attacker.stats.maxHp;
        
        // Sauvegarder immédiatement après level up
        await GameDataService.saveCharacter(attacker);
        debugPrint('💾 Personnage sauvegardé après level up');
        
        // Afficher l'animation de level up
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LevelUpAnimation(
              character: attacker,
              statIncreases: statIncreases,
              onComplete: () => Navigator.pop(context),
            ),
          );
        }
      } else {
        debugPrint('❌ Pas de level up (${attacker.xp}/$xpNeeded)');
        // Sauvegarder l'XP même sans level up
        await GameDataService.saveCharacter(attacker);
        debugPrint('💾 XP sauvegardée sans level up');
      }
    }

    // Mettre à jour les HP et retirer les morts
    setState(() {
      // Mettre à jour les HP dans charactersMap
      final attackerChar = charactersMap[attackerUnit.unitId];
      final defenderChar = charactersMap[defenderUnit.unitId];
      
      if (attackerChar != null) {
        attackerChar.currentHp = result.attackerFinalHp;
      }
      
      if (defenderChar != null) {
        defenderChar.currentHp = result.defenderFinalHp;
      }

      if (result.defenderFinalHp <= 0) {
        units.removeWhere((u) => u.unitId == defenderUnit.unitId);
      }

      if (result.attackerFinalHp <= 0) {
        units.removeWhere((u) => u.unitId == attackerUnit.unitId);
      }

      selectedUnit = null;
      highlightedTiles.clear();
      attackableTiles.clear();
    });

    // Vérifier conditions de victoire/défaite
    _checkBattleEnd();
    
    // Après le combat, terminer le tour de l'unité attaquante
    if (attackerUnit.isPlayer) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _endCurrentUnitTurn();
        }
      });
    }
  }

  void _checkBattleEnd() {
    final hasPlayerUnits = units.any((u) => u.isPlayer);
    final hasEnemyUnits = units.any((u) => !u.isPlayer);

    if (!hasEnemyUnits) {
      _showVictoryDialog();
    } else if (!hasPlayerUnits) {
      _showDefeatDialog();
    }
  }

  Future<void> _showVictoryDialog() async {
    // Calculer les récompenses avec un dé si c'est un stage de campagne
    int finalGold = 0;
    int finalXP = 0;
    DiceRoll? lootRoll;

    if (widget.stage != null) {
      // Calculer la Luck moyenne de l'équipe
      final teamLuck = widget.team.isEmpty 
          ? 0 
          : widget.team.map((c) => c.totalLuck).reduce((a, b) => a + b) ~/ widget.team.length;
      
      // 🎲 Lancer un D12 pour le loot de boss
      lootRoll = DiceService.roll(DiceType.d12, luckBonus: teamLuck);
      
      // Afficher l'animation du dé
      if (mounted) {
        await DiceRollDialog.show(
          context,
          roll: lootRoll,
          title: '🎲 Loot de Boss',
        );
      }

      // Déterminer le multiplicateur de récompenses selon le résultat
      double multiplier = 1.0;
      if (lootRoll.isCritical || lootRoll.total >= 11) {
        multiplier = 2.0; // Légendaire : ×2 récompenses
      } else if (lootRoll.total >= 9) {
        multiplier = 1.5; // Épique : ×1.5 récompenses
      } else if (lootRoll.total >= 6) {
        multiplier = 1.25; // Rare : ×1.25 récompenses
      } else if (lootRoll.total <= 3) {
        multiplier = 0.75; // Mauvais : ×0.75 récompenses
      }

      finalGold = (widget.stage!.rewardGold * multiplier).round();
      finalXP = (widget.stage!.rewardXP * multiplier).round();
      
      debugPrint('Stage terminé ! Dé : ${lootRoll.total} -> Multiplicateur: ${multiplier}x');
      debugPrint('Récompenses: ${finalGold}G, ${finalXP}XP');
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.victory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context)!.allEnemiesDefeated),
            if (widget.stage != null && lootRoll != null) ...[
              const SizedBox(height: 16),
              // Afficher le résultat du dé
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DiceResultWidget(roll: lootRoll, size: 50),
                  const SizedBox(width: 12),
                  Text(
                    _getLootQualityText(lootRoll),
                    style: TextStyle(
                      color: _getLootQualityColor(lootRoll),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '+$finalGold Or',
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '+$finalXP XP',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog
              Navigator.pop(context, true); // Campaign screen avec succès
            },
            child: Text(S.of(context)!.returnButton),
          ),
        ],
      ),
    );
  }

  String _getLootQualityText(DiceRoll roll) {
    if (roll.isCritical || roll.total >= 11) {
      return 'Butin Légendaire ! (×2)';
    } else if (roll.total >= 9) {
      return 'Butin Épique ! (×1.5)';
    } else if (roll.total >= 6) {
      return 'Butin Rare (×1.25)';
    } else if (roll.total <= 3) {
      return 'Butin Médiocre... (×0.75)';
    }
    return 'Butin Standard';
  }

  Color _getLootQualityColor(DiceRoll roll) {
    if (roll.isCritical || roll.total >= 11) {
      return Colors.amber;
    } else if (roll.total >= 9) {
      return Colors.purple;
    } else if (roll.total >= 6) {
      return Colors.blue;
    } else if (roll.total <= 3) {
      return Colors.grey;
    }
    return Colors.white;
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.defeat),
        content: Text(S.of(context)!.allCharactersDefeated),
        backgroundColor: Colors.red.shade900,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog
              Navigator.pop(context, false); // Campaign screen avec échec
            },
            child: Text(S.of(context)!.returnButton),
          ),
        ],
      ),
    );
  }

  void _highlightMoveAndAttackOptions(UnitPosition unit, Character character) {
    highlightedTiles.clear();
    attackableTiles.clear();

    // L'unité peut se déplacer de son mouvement total
    final movementRange = character.stats.movement;
    
    // Calculer toutes les cases accessibles avec pathfinding
    final reachableTiles = mapData.getReachableTiles(unit.x, unit.y, movementRange);
    
    // Convertir en format Set<String> pour l'UI
    for (final tile in reachableTiles) {
      highlightedTiles.add('${tile.x},${tile.y}');
    }

    // Obtenir la portée d'attaque depuis l'arme équipée
    int attackRange = 1; // Par défaut
    if (character.weapon != null) {
      attackRange = character.weapon!.attackRange;
    }
    
    // TOUJOURS calculer les cases attaquables (zone rouge visible en permanence)
    final attackTiles = mapData.getAttackableTiles(reachableTiles, unit.x, unit.y, attackRange);
    
    // Convertir en format Set<String> pour l'UI
    for (final tile in attackTiles) {
      attackableTiles.add('${tile.x},${tile.y}');
    }

    setState(() {});
  }

  void _onTileTap(int x, int y) {
    if (selectedUnit == null) return;

    // Vérifier si la case est dans les mouvements possibles
    if (!highlightedTiles.contains('$x,$y')) {
      return;
    }

    final character = charactersMap[selectedUnit!.unitId];
    if (character == null) return;

    // Calculer le chemin optimal vers la destination
    final pathResult = mapData.findPath(
      selectedUnit!.x, 
      selectedUnit!.y, 
      x, 
      y, 
      character.stats.movement
    );
    
    if (pathResult == null) return;

    // Déplacer l'unité directement à la destination
    setState(() {
      final index = units.indexWhere((u) => u.unitId == selectedUnit!.unitId);
      if (index != -1) {
        units[index] = units[index].copyWith(x: x, y: y);
        selectedUnit = units[index];
        
        // Après déplacement, l'unité a terminé son action
        // On termine automatiquement son tour
        Future.delayed(const Duration(milliseconds: 300), () {
          _endCurrentUnitTurn();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A237E),
              const Color(0xFF311B92),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 20),

              // Map avec scroll
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TacticalMapWidget(
                        mapData: mapData,
                        units: units,
                        selectedUnit: selectedUnit,
                        onUnitTap: _onUnitTap,
                        onTileTap: _onTileTap,
                        tileSize: 70,
                        showGrid: true,
                        highlightedTiles: highlightedTiles,
                        attackableTiles: attackableTiles,
                        unitsWhoActed: _unitsWhoActed,
                      ),
                    ),
                  ),
                ),
              ),

              // Panel inférieur
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentCharacter = selectedUnit != null ? charactersMap[selectedUnit!.unitId] : null;
    
    return Container(
      decoration: BoxDecoration(
        color: _isPlayerPhase 
            ? Colors.blue.withOpacity(0.3) 
            : Colors.red.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: _isPlayerPhase ? Colors.blue : Colors.red,
            width: 3,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Ligne supérieure: Character detail ou placeholder
            if (currentCharacter != null)
              CharacterCompactView(
                character: currentCharacter,
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  mapData.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bouton Exit (porte rouge)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showExitConfirmation(context),
              icon: const Text('🚪', style: TextStyle(fontSize: 20)),
              label: const Text('Exit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Bouton End Turn
          Expanded(
            child: ElevatedButton.icon(
              onPressed: selectedUnit != null && selectedUnit!.isPlayer 
                  ? () {
                      _endCurrentUnitTurn();
                    }
                  : null,
              icon: const Icon(Icons.skip_next),
              label: Text(S.of(context)!.endTurn),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedUnit != null && selectedUnit!.isPlayer 
                    ? Colors.orange 
                    : Colors.grey.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Quitter la mission',
      message: 'Êtes-vous sûr de vouloir quitter ce stage ? Toute progression non sauvegardée sera perdue.',
      confirmText: 'Quitter',
      cancelText: 'Rester',
      confirmColor: Colors.red,
      icon: Icons.exit_to_app,
    );
    
    if (confirmed && context.mounted) {
      Navigator.pop(context);
    }
  }

  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: const TacticalMapLegend(),
      ),
    );
  }
  Future<Skill?> _showAttackChoiceDialog(Character character, Skill activeSkill) async {
    return showDialog<Skill?>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A47),
        title: Text(
          S.of(context)!.chooseAttack,
          style: const TextStyle(color: Colors.amber),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Attaque avec arme
            ListTile(
              leading: IconDisplay(
                icon: character.weapon?.displayIcon ?? '⚔️',
                size: 32,
              ),
              title: Text(
                character.weapon?.name ?? S.of(context)!.basicAttack,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${S.of(context)!.damage}: ${character.totalOffensive}',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () => Navigator.pop(context, null), // null = attaque normale
            ),
            const Divider(color: Colors.white24),
            // Attaque avec compétence
            ListTile(
              leading: IconDisplay(
                icon: activeSkill.displayIcon,
                size: 32,
              ),
              title: Text(
                activeSkill.name,
                style: const TextStyle(color: Colors.amber),
              ),
              subtitle: Text(
                activeSkill.description,
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () => Navigator.pop(context, activeSkill),
            ),
          ],
        ),
      ),
    );
  }

  // Calculer les augmentations de stats au level up (style Fire Emblem avec RNG)
  Map<String, int> _calculateStatIncreases(Character character) {
    final increases = <String, int>{};
    
    // Taux de croissance basés sur la classe
    final growthRates = _getGrowthRates(character.persona.characterClass);
    
    // Pour chaque stat, lancer un "dé" pour voir si elle augmente
    growthRates.forEach((stat, rate) {
      final random = (DateTime.now().microsecond % 100) / 100.0;
      increases[stat] = random < rate ? 1 : 0;
    });
    
    // Garantir au moins 2 stats qui augmentent
    int totalIncreases = increases.values.fold(0, (sum, val) => sum + val);
    while (totalIncreases < 2) {
      final stats = increases.keys.toList();
      final randomStat = stats[DateTime.now().microsecond % stats.length];
      if (increases[randomStat]! < 1) {
        increases[randomStat] = 1;
        totalIncreases++;
      }
    }
    
    return increases;
  }

  // Taux de croissance par classe (probabilité d'augmentation)
  Map<String, double> _getGrowthRates(PersonaClass characterClass) {
    switch (characterClass) {
      case PersonaClass.warrior:
        return {
          'HP': 0.80,
          'ATK': 0.70,
          'DEF': 0.60,
          'SPD': 0.40,
          'MAG': 0.20,
          'LCK': 0.30,
        };
      case PersonaClass.mage:
        return {
          'HP': 0.50,
          'ATK': 0.30,
          'DEF': 0.40,
          'SPD': 0.50,
          'MAG': 0.80,
          'LCK': 0.40,
        };
      case PersonaClass.cleric:
        return {
          'HP': 0.60,
          'ATK': 0.40,
          'DEF': 0.50,
          'SPD': 0.50,
          'MAG': 0.70,
          'LCK': 0.60,
        };
      case PersonaClass.peasant:
        return {
          'HP': 0.70,
          'ATK': 0.60,
          'DEF': 0.50,
          'SPD': 0.60,
          'MAG': 0.30,
          'LCK': 0.50,
        };
    }
  }
}
