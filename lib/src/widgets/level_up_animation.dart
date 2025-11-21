import 'package:flutter/material.dart';
import '../models/character.dart';

/// Animation de level up inspirée de Fire Emblem
class LevelUpAnimation extends StatefulWidget {
  final Character character;
  final Map<String, int> statIncreases; // Stats qui ont augmenté
  final VoidCallback onComplete;

  const LevelUpAnimation({
    super.key,
    required this.character,
    required this.statIncreases,
    required this.onComplete,
  });

  @override
  State<LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showStats = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Afficher les stats après 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showStats = true);
      }
    });

    // Fermer automatiquement après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade700,
                    Colors.amber.shade900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône étoile
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 6.28, // 2π pour une rotation complète
                        child: Icon(
                          Icons.stars,
                          size: 80 + (value * 20),
                          color: Colors.white,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // LEVEL UP!
                  const Text(
                    'LEVEL UP!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nom du personnage et nouveau niveau
                  Text(
                    '${widget.character.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Niveau ${widget.character.level}',
                    style: TextStyle(
                      color: Colors.amber.shade100,
                      fontSize: 20,
                    ),
                  ),

                  // Stats augmentées
                  if (_showStats) ...[
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white54, thickness: 2),
                    const SizedBox(height: 16),
                    ...widget.statIncreases.entries.map((entry) {
                      return _buildStatIncrease(entry.key, entry.value);
                    }),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatIncrease(String statName, int increase) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 50, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    child: Text(
                      statName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.lightGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+$increase',
                    style: const TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
