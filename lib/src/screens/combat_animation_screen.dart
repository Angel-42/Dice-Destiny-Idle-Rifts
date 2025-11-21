import 'dart:async';
import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/skill.dart';

/// Écran de combat animé 1v1 inspiré de Fire Emblem
/// Affiche une scène isolée avec les sprites des deux combattants
class CombatAnimationScreen extends StatefulWidget {
  final Character attacker;
  final Character defender;
  final Skill? attackerSkill; // Compétence active utilisée par l'attaquant (null = attaque normale)
  final Function(CombatResult) onCombatEnd;

  const CombatAnimationScreen({
    super.key,
    required this.attacker,
    required this.defender,
    this.attackerSkill,
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
  
  // Pop-ups de dégâts
  int? _attackerDamagePopup;
  int? _defenderDamagePopup;
  
  List<String> _combatLog = [];
  CombatPhase _phase = CombatPhase.intro;
  int _xpGained = 0;

  @override
  void initState() {
    super.initState();
    _attackerCurrentHp = widget.attacker.currentHp;
    _defenderCurrentHp = widget.defender.currentHp;

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

    // Démarrer le combat après un court délai
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

  Future<void> _startCombat() async {
    setState(() {
      _phase = CombatPhase.fighting;
    });

    await _fadeController.forward();

    // Déterminer l'ordre d'attaque basé sur la vitesse
    final attackerSpeed = widget.attacker.totalSpeed;
    final defenderSpeed = widget.defender.totalSpeed;

    List<Character> turnOrder = attackerSpeed >= defenderSpeed
        ? [widget.attacker, widget.defender]
        : [widget.defender, widget.attacker];

    // Tour 1: Premier attaquant
    await _performAttack(turnOrder[0], turnOrder[1]);

    // Vérifier si le combat continue
    if (_defenderCurrentHp > 0 && _attackerCurrentHp > 0) {
      await Future.delayed(const Duration(milliseconds: 800));
      // Tour 2: Contre-attaque
      await _performAttack(turnOrder[1], turnOrder[0]);
    }

    // Fin du combat
    await Future.delayed(const Duration(milliseconds: 1000));
    _endCombat();
  }

  Future<void> _performAttack(Character attacker, Character defender) async {
    setState(() {
      _currentAction = '${attacker.name} attaque !';
      _combatLog.add(_currentAction);
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Calculer les dégâts
    final damage = _calculateDamage(attacker, defender);
    
    // Afficher le pop-up de dégâts
    setState(() {
      if (defender.id == widget.defender.id) {
        _defenderDamagePopup = damage;
      } else {
        _attackerDamagePopup = damage;
      }
    });
    
    // Shake animation pour le défenseur
    await _shakeController.forward();
    await _shakeController.reverse();

    // Appliquer les dégâts
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
    
    // Cacher le pop-up
    setState(() {
      _attackerDamagePopup = null;
      _defenderDamagePopup = null;
    });
  }

  int _calculateDamage(Character attacker, Character defender) {
    // Utiliser la vraie formule du Character
    // Si c'est l'attaquant principal et qu'il a une compétence, l'utiliser
    final useSkill = attacker.id == widget.attacker.id ? widget.attackerSkill : null;
    
    if (attacker.persona.characterClass.isMagical) {
      return attacker.calculateMagicDamage(defender, activeSkill: useSkill);
    } else {
      return attacker.calculatePhysicalDamage(defender, activeSkill: useSkill);
    }
  }

  void _endCombat() {
    final attackerWon = _defenderCurrentHp <= 0;
    final defenderDefeated = _defenderCurrentHp <= 0;

    // Calculer l'XP gagnée
    _xpGained = defenderDefeated ? 50 : 20; // 50 XP si tué, 20 XP sinon

    setState(() {
      _phase = CombatPhase.result;
    });

    // Mettre à jour les HP actuels des personnages
    widget.attacker.currentHp = _attackerCurrentHp;
    widget.defender.currentHp = _defenderCurrentHp;

    final result = CombatResult(
      attackerWon: attackerWon,
      defenderWon: false, // Pas de défaite pour l'attaquant
      attackerFinalHp: _attackerCurrentHp,
      defenderFinalHp: _defenderCurrentHp,
      combatLog: _combatLog,
      xpGained: _xpGained,
    );

    // Attendre avant de fermer
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
              // Background effet
              _buildBackground(),

              // Combattants
              Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // HP Bars en haut
                  _buildTopPanel(),

                  const Spacer(),

                  // Zone de combat avec sprites
                  _buildCombatZone(),

                  const Spacer(),

                  // Log de combat en bas
                  _buildCombatLog(),
                  
                  const SizedBox(height: 20),
                ],
              ),

              // Résultat final
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
    // Utiliser le fullsize sprite s'il existe
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
          const Text(
            'COMBAT LOG',
            style: TextStyle(
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
              const Text(
                'COMBAT TERMINÉ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                defenderDefeated
                    ? '${widget.defender.name} vaincu !'
                    : 'Combat victorieux !',
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
