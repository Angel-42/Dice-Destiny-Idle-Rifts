import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/character.dart';
import '../models/skill.dart';
import '../models/dice.dart';
import '../models/animation_state.dart';
import '../widgets/dice_animation_widget.dart';
import '../widgets/combat_animated_sprite.dart';
import '../services/game_data_service.dart';

/// Écran de combat animé 1v1 inspiré de Fire Emblem
/// Affiche une scène isolée avec les sprites des deux combattants
class CombatAnimationScreen extends StatefulWidget {
  final Character attacker;
  final Character defender;
  final Skill? attackerSkill; // Compétence active utilisée par l'attaquant (null = attaque normale)
  final bool canDefenderCounter; // Le défenseur peut-il riposter ?
  final Function(CombatResult) onCombatEnd;

  const CombatAnimationScreen({
    super.key,
    required this.attacker,
    required this.defender,
    this.attackerSkill,
    this.canDefenderCounter = true, // Par défaut, le défenseur peut riposter
    required this.onCombatEnd,
  });

  @override
  State<CombatAnimationScreen> createState() => _CombatAnimationScreenState();
}

class _CombatAnimationScreenState extends State<CombatAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  String _currentAction = '';
  int _attackerCurrentHp = 0;
  int _defenderCurrentHp = 0;
  
  int? _attackerDamagePopup;
  int? _defenderDamagePopup;
  
  List<String> _combatLog = [];
  CombatPhase _phase = CombatPhase.intro;
  int _xpGained = 0;

  // États d'animation pour les combattants
  AnimationState _attackerAnimState = AnimationState.idle;
  AnimationState _defenderAnimState = AnimationState.idle;

  @override
  void initState() {
    super.initState();
    _attackerCurrentHp = widget.attacker.currentHp;
    _defenderCurrentHp = widget.defender.currentHp;

    // Enregistrer la rencontre avec le défenseur dans le bestiaire
    _trackEnemyEncounter();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    Future.delayed(const Duration(milliseconds: 500), () {
      _startCombat();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Enregistre la rencontre avec l'ennemi dans le bestiaire
  Future<void> _trackEnemyEncounter() async {
    try {
      final player = await GameDataService.getPlayer();
      if (player != null) {
        player.encounterEnemy(widget.defender.id);
        await GameDataService.savePlayer(player);
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'enregistrement de la rencontre: $e');
    }
  }

  /// Enregistre la défaite de l'ennemi dans le bestiaire
  Future<void> _trackEnemyDefeat() async {
    try {
      final player = await GameDataService.getPlayer();
      if (player != null) {
        player.defeatEnemy(widget.defender.id);
        await GameDataService.savePlayer(player);
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'enregistrement de la défaite: $e');
    }
  }

  Future<void> _startCombat() async {
    setState(() {
      _phase = CombatPhase.fighting;
    });

    await _fadeController.forward();

    // L'ATTAQUANT (celui qui a initié le combat) attaque TOUJOURS en premier
    await _performAttack(widget.attacker, widget.defender);

    if (_defenderCurrentHp > 0 && _attackerCurrentHp > 0) {
      if (widget.canDefenderCounter) {
        await Future.delayed(const Duration(milliseconds: 800));
        await _performAttack(widget.defender, widget.attacker);
      } else {
        setState(() {
          _currentAction = '${widget.defender.name} est hors de portée pour riposter !';
          _combatLog.add(_currentAction);
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    _endCombat();
  }

  Future<void> _performAttack(Character attacker, Character defender, {bool allowDoubleAttack = true}) async {
    final isAttackerPlayer = attacker.id == widget.attacker.id;
    
    // Animation d'attaque pour l'attaquant
    setState(() {
      if (isAttackerPlayer) {
        _attackerAnimState = AnimationState.attack;
      } else {
        _defenderAnimState = AnimationState.attack;
      }
      _currentAction = '${attacker.name} attaque !';
      _combatLog.add(_currentAction);
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final (damage, isCritical) = _calculateDamageWithCrit(attacker, defender);
    
    if (isCritical) {
      final critRoll = DiceRoll(
        type: DiceType.d20,
        result: 20,
        isCritical: true,
      );
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (context) => DiceAnimationWidget(
          roll: critRoll,
          onComplete: () => Navigator.of(context).pop(),
          duration: const Duration(milliseconds: 800),
          size: 100,
          showDescription: false,
        ),
      );
      
      setState(() {
        _currentAction = '✨ CRITIQUE ! ✨';
        _combatLog.add(_currentAction);
      });
      
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    // Animation de dégâts pour le défenseur
    setState(() {
      if (isAttackerPlayer) {
        _defenderAnimState = AnimationState.hit;
        _defenderDamagePopup = damage;
      } else {
        _attackerAnimState = AnimationState.hit;
        _attackerDamagePopup = damage;
      }
    });
    
    await _shakeController.forward();
    await _shakeController.reverse();

    setState(() {
      if (defender.id == widget.defender.id) {
        _defenderCurrentHp = (_defenderCurrentHp - damage).clamp(0, defender.stats.maxHp);
      } else {
        _attackerCurrentHp = (_attackerCurrentHp - damage).clamp(0, attacker.stats.maxHp);
      }
      _currentAction = '${defender.name} subit $damage dégâts !';
      _combatLog.add(_currentAction);
    });

    await Future.delayed(const Duration(milliseconds: 800));
    
    // Revenir à l'état idle
    setState(() {
      _attackerDamagePopup = null;
      _defenderDamagePopup = null;
      _attackerAnimState = AnimationState.idle;
      _defenderAnimState = AnimationState.idle;
    });

    // Vérifier si le défenseur est toujours vivant ET si la double attaque est autorisée
    if (allowDoubleAttack) {
      final defenderIsAlive = (defender.id == widget.defender.id && _defenderCurrentHp > 0) ||
                              (defender.id == widget.attacker.id && _attackerCurrentHp > 0);
      
      if (defenderIsAlive && _checkDoubleAttack(attacker)) {
        setState(() {
          _currentAction = '${attacker.name} enchaîne avec une double attaque !';
          _combatLog.add(_currentAction);
        });
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        await _performAttack(attacker, defender, allowDoubleAttack: false);
      }
    }
  }

  (int, bool) _calculateDamageWithCrit(Character attacker, Character defender) {
    final useSkill = attacker.id == widget.attacker.id ? widget.attackerSkill : null;
    
    if (attacker.persona.characterClass.isMagical) {
      return attacker.calculateMagicDamageWithCrit(defender, activeSkill: useSkill);
    } else {
      return attacker.calculatePhysicalDamageWithCrit(defender, activeSkill: useSkill);
    }
  }

  /// Calcule la probabilité de double attaque basée sur la vitesse et la chance
  /// Formule: (Speed/2 + Luck/3) / 100
  /// Avec des stats élevées (Speed 30, Luck 30), on obtient ~25% de chance
  /// Au début du jeu (Speed 10, Luck 5), on obtient ~6.6% de chance
  bool _checkDoubleAttack(Character attacker) {
    final speed = attacker.totalSpeed;
    final luck = attacker.totalLuck;
    
    final doubleAttackChance = (speed / 2.0) + (luck / 3.0);
    
    final random = (DateTime.now().microsecondsSinceEpoch % 10000) / 100.0;
    
    return random < doubleAttackChance;
  }

  void _endCombat() {
    final attackerWon = _defenderCurrentHp <= 0;
    final defenderDefeated = _defenderCurrentHp <= 0;

    _xpGained = defenderDefeated ? 50 : 20;

    // Enregistrer la défaite de l'ennemi dans le bestiaire
    if (defenderDefeated) {
      _trackEnemyDefeat();
    }

    // Animations de fin
    if (defenderDefeated) {
      setState(() {
        _defenderAnimState = AnimationState.death;
        _attackerAnimState = AnimationState.victory;
      });
    } else if (_attackerCurrentHp <= 0) {
      setState(() {
        _attackerAnimState = AnimationState.death;
      });
    }

    setState(() {
      _phase = CombatPhase.result;
    });

    final result = CombatResult(
      attackerWon: attackerWon,
      defenderWon: false,
      attackerFinalHp: _attackerCurrentHp,
      defenderFinalHp: _defenderCurrentHp,
      combatLog: _combatLog,
      xpGained: _xpGained,
    );

    Future.delayed(const Duration(seconds: 2), () {
      widget.onCombatEnd(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2C0A0A),
              const Color(0xFF8B1A1A),
              const Color(0xFF4A0E0E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackground(),

              Column(
                children: [
                  const SizedBox(height: 40),
                  
                  _buildTopPanel(),

                  const Spacer(),

                  _buildCombatZone(),

                  const Spacer(),

                  _buildCombatLog(),
                  
                  const SizedBox(height: 20),
                ],
              ),

              if (_phase == CombatPhase.result) _buildResultOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/logo/logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildTopPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildHpBar(widget.attacker, _attackerCurrentHp, false)),
          const SizedBox(width: 20),
          Expanded(child: _buildHpBar(widget.defender, _defenderCurrentHp, true)),
        ],
      ),
    );
  }

  Widget _buildHpBar(Character character, int currentHp, bool isDefender) {
    final hpPercent = currentHp / character.stats.maxHp;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefender ? Colors.red : Colors.blue,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            character.name,
            style: TextStyle(
              color: isDefender ? Colors.red : Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HP',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '$currentHp / ${character.stats.maxHp}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: hpPercent,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hpPercent > 0.5
                      ? Colors.green
                      : hpPercent > 0.25
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombatZone() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            // Attaquant (gauche)
            Positioned(
              left: 50,
              bottom: 20,
              child: _buildCombatant(widget.attacker, false),
            ),

            // Défenseur (droite)
            Positioned(
              right: 50,
              bottom: 20,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: _buildCombatant(widget.defender, true),
              ),
            ),

            // Pop-up de dégâts pour l'attaquant
            if (_attackerDamagePopup != null)
              Positioned(
                left: 120,
                bottom: 180,
                child: _buildDamagePopup(_attackerDamagePopup!),
              ),

            // Pop-up de dégâts pour le défenseur
            if (_defenderDamagePopup != null)
              Positioned(
                right: 120,
                bottom: 180,
                child: _buildDamagePopup(_defenderDamagePopup!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatant(Character character, bool isDefender) {
    final currentAnimState = isDefender ? _defenderAnimState : _attackerAnimState;
    
    // Si le personnage a des animations de combat configurées, les utiliser
    if (character.appearance.combatAnimations != null && 
        character.appearance.combatAnimations!.hasAnimations) {
      return CombatAnimatedSprite(
        animationSet: character.appearance.combatAnimations!,
        currentState: currentAnimState,
        width: 150,
        height: 250,
        flipHorizontal: !isDefender, // L'attaquant regarde vers la droite
        fallbackBuilder: () => _buildFallbackCombatant(character, isDefender),
      );
    }
    
    // Sinon, utiliser le fullsize sprite statique s'il existe
    if (character.appearance.fullsize != null) {
      return Container(
        width: 150,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isDefender ? Colors.red : Colors.blue).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Image.asset(
          character.appearance.fullsize!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackCombatant(character, isDefender);
          },
        ),
      );
    }

    return _buildFallbackCombatant(character, isDefender);
  }

  Widget _buildFallbackCombatant(Character character, bool isDefender) {
    return Container(
      width: 150,
      height: 250,
      decoration: BoxDecoration(
        color: Color(character.appearance.colorValue).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefender ? Colors.red : Colors.blue,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDefender ? Colors.red : Colors.blue).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              character.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Color(character.appearance.colorValue),
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              character.name,
              style: TextStyle(
                color: Color(character.appearance.colorValue),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatLog() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.combatLog,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.amber),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _combatLog.length,
              itemBuilder: (context, index) {
                final reversedIndex = _combatLog.length - 1 - index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _combatLog[reversedIndex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDamagePopup(int damage) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -30 * value),
          child: Opacity(
            opacity: 1.0 - value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.8),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Text(
                '-$damage',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultOverlay() {
    final defenderDefeated = _defenderCurrentHp <= 0;

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                defenderDefeated ? Icons.stars : Icons.check_circle,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context)!.combatFinished,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                defenderDefeated
                    ? S.of(context)!.enemyDefeated(widget.defender.name)
                    : S.of(context)!.combatVictorious,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '+$_xpGained XP',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CombatPhase {
  intro,
  fighting,
  result,
}

class CombatResult {
  final bool attackerWon;
  final bool defenderWon;
  final int attackerFinalHp;
  final int defenderFinalHp;
  final List<String> combatLog;
  final int xpGained;

  CombatResult({
    required this.attackerWon,
    required this.defenderWon,
    required this.attackerFinalHp,
    required this.defenderFinalHp,
    required this.combatLog,
    required this.xpGained,
  });

  bool get isDraw => attackerWon && defenderWon;
}
