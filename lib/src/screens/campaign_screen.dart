import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/map_data.dart';
import '../models/character.dart';
import '../models/persona.dart';
import '../models/skill.dart';
import '../widgets/tactical_map_widget.dart';
import '../widgets/character_detail_popup.dart';
import '../widgets/level_up_animation.dart';
import '../widgets/icon_display.dart';
import '../screens/combat_animation_screen.dart';
import '../services/game_data_service.dart';
import '../data/enemy_database.dart';

/// Écran de campagne avec map tactique et déplacement
class CampaignScreen extends StatefulWidget {
  final List<Character> team;

  const CampaignScreen({
    super.key,
    required this.team,
  });

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  late TacticalMapData mapData;
  late List<UnitPosition> units;
  late Map<String, Character> charactersMap;
  UnitPosition? selectedUnit;
  Set<String> highlightedTiles = {};
  Set<String> attackableTiles = {};
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
  }

  void _onUnitTap(UnitPosition unit) {
    final character = charactersMap[unit.unitId];
    if (character == null) return;

    if (!unit.isPlayer && selectedUnit != null) {
      _showEnemyDetailAndAttack(character, unit);
      return;
    }

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
    } else {
      _showCharacterDetail(character, unit, false);
    }
  }

  void _showCharacterDetail(Character character, UnitPosition unit, bool canAttack) {
    showDialog(
      context: context,
      builder: (context) => CharacterDetailPopup(
        character: character,
        isEnemy: !unit.isPlayer,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showEnemyDetailAndAttack(Character enemy, UnitPosition enemyUnit) {
    final selectedChar = charactersMap[selectedUnit!.unitId];
    if (selectedChar == null) return;

    final distance = _calculateDistance(selectedUnit!.x, selectedUnit!.y, enemyUnit.x, enemyUnit.y);
    final range = selectedChar.stats.range;

    if (distance > range) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context)!.targetOutOfRange(distance, range)),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Afficher le popup avec option d'attaque
    showDialog(
      context: context,
      builder: (context) => CharacterDetailPopup(
        character: enemy,
        isEnemy: true,
        onClose: () => Navigator.pop(context),
        onAttack: () {
          Navigator.pop(context);
          _startCombat(selectedChar, enemy, selectedUnit!, enemyUnit);
        },
      ),
    );
  }

  int _calculateDistance(int x1, int y1, int x2, int y2) {
    return (x1 - x2).abs() + (y1 - y2).abs(); // Distance de Manhattan
  }

  Future<void> _startCombat(Character attacker, Character defender, 
      UnitPosition attackerUnit, UnitPosition defenderUnit) async {
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

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.victory),
        content: Text(S.of(context)!.allEnemiesDefeated),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog
              Navigator.pop(context); // Campaign screen
            },
            child: Text(S.of(context)!.returnButton),
          ),
        ],
      ),
    );
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
              Navigator.pop(context); // Campaign screen
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

    // Cases de mouvement adjacentes
    final directions = [
      (0, -1), (0, 1), (-1, 0), (1, 0),
    ];

    for (final (dx, dy) in directions) {
      final newX = unit.x + dx;
      final newY = unit.y + dy;

      if (mapData.isWalkable(newX, newY)) {
        final occupant = units.firstWhere(
          (u) => u.x == newX && u.y == newY,
          orElse: () => UnitPosition(unitId: '', x: -1, y: -1, name: ''),
        );
        
        if (occupant.x == -1) {
          highlightedTiles.add('$newX,$newY');
        }
      }
    }

    // Zones d'attaque (basées sur la portée)
    final range = character.stats.range;
    for (var u in units) {
      if (!u.isPlayer) {
        final distance = _calculateDistance(unit.x, unit.y, u.x, u.y);
        if (distance <= range) {
          attackableTiles.add('${u.x},${u.y}');
        }
      }
    }

    setState(() {});
  }

  void _highlightMoveOptions(UnitPosition unit) {
    highlightedTiles.clear();

    final directions = [
      (0, -1),
      (0, 1),
      (-1, 0),
      (1, 0),
    ];

    for (final (dx, dy) in directions) {
      final newX = unit.x + dx;
      final newY = unit.y + dy;

      // Vérifier si la case est valide et marchable
      if (mapData.isWalkable(newX, newY) && !mapData.isOccupied(newX, newY)) {
        highlightedTiles.add('$newX,$newY');
      }
    }

    setState(() {});
  }

  void _onTileTap(int x, int y) {
    if (selectedUnit == null) return;

    // Vérifier si la case est dans les mouvements possibles
    if (!highlightedTiles.contains('$x,$y')) {
      return;
    }

    // Déplacer l'unité
    setState(() {
      final index = units.indexWhere((u) => u.unitId == selectedUnit!.unitId);
      if (index != -1) {
        units[index] = units[index].copyWith(x: x, y: y);
        selectedUnit = units[index];
        
        // Mettre à jour les cases en surbrillance
        _highlightMoveOptions(selectedUnit!);
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapData.name,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                if (mapData.description != null)
                  Text(
                    mapData.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          // Icône d'aide
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () => _showLegend(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border(
          top: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          // Info unité sélectionnée
          Expanded(
            child: selectedUnit != null
                ? Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedUnit!.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            selectedUnit!.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedUnit!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Position: (${selectedUnit!.x}, ${selectedUnit!.y})',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    'Sélectionnez votre personnage pour vous déplacer',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),

          // Bouton fin de tour
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedUnit = null;
                highlightedTiles.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context)!.turnEnded),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: Text(S.of(context)!.endTurn),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
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
