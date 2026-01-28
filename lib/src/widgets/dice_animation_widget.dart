import 'package:flutter/material.dart';
import 'dart:math';
import '../models/dice.dart';

/// Widget d'animation de dé modulable et réutilisable
class DiceAnimationWidget extends StatefulWidget {
  final DiceRoll roll;
  final VoidCallback? onComplete;
  final Duration duration;
  final double size;
  final bool showDescription;

  const DiceAnimationWidget({
    super.key,
    required this.roll,
    this.onComplete,
    this.duration = const Duration(milliseconds: 1200),
    this.size = 120,
    this.showDescription = true,
  });

  @override
  State<DiceAnimationWidget> createState() => _DiceAnimationWidgetState();
}

class _DiceAnimationWidgetState extends State<DiceAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  
  int _displayedNumber = 1;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Animation de rotation (4 tours complets)
    _rotationAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation de scale (effet bounce)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Changer le nombre affiché pendant l'animation
    _controller.addListener(() {
      if (_controller.value < 0.85) {
        setState(() {
          _displayedNumber = _random.nextInt(widget.roll.maxValue) + 1;
        });
      } else {
        setState(() {
          _displayedNumber = widget.roll.result;
        });
      }
    });

    // Callback de fin d'animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete?.call();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Le dé animé
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: _buildDice(),
              ),
            ),
            
            // Description (optionnel)
            if (widget.showDescription && _controller.value >= 0.85) ...[
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _controller.value >= 0.9 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Text(
                      widget.roll.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.size * 0.18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.roll.isCritical || widget.roll.isCriticalFailure) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.roll.isCritical ? '🌟 CRITIQUE !' : '💀 ÉCHEC CRITIQUE',
                        style: TextStyle(
                          color: widget.roll.isCritical ? Colors.amber : Colors.red,
                          fontSize: widget.size * 0.15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDice() {
    final color = _getDiceColor();
    
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.9),
            color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(widget.size * 0.15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          '$_displayedNumber',
          style: TextStyle(
            fontSize: widget.size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDiceColor() {
    // Pendant l'animation (85% premier)
    if (_controller.value < 0.85) {
      return Colors.grey.shade700;
    }
    
    // Résultat final avec couleur selon performance
    switch (widget.roll.resultColor) {
      case DiceResultColor.legendary:
        return Colors.amber;
      case DiceResultColor.epic:
        return Colors.purple;
      case DiceResultColor.rare:
        return Colors.blue;
      case DiceResultColor.common:
        return Colors.green;
      case DiceResultColor.poor:
        return Colors.grey;
      case DiceResultColor.failure:
        return Colors.red.shade900;
    }
  }
}

/// Dialog modal pour afficher l'animation de dé en plein écran
class DiceRollDialog extends StatelessWidget {
  final DiceRoll roll;
  final String? title;
  final VoidCallback? onComplete;
  final Duration duration;

  const DiceRollDialog({
    super.key,
    required this.roll,
    this.title,
    this.onComplete,
    this.duration = const Duration(milliseconds: 1200),
  });

  /// Affiche le dialog et retourne le résultat
  static Future<DiceRoll> show(
    BuildContext context, {
    required DiceRoll roll,
    String? title,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => DiceRollDialog(
        roll: roll,
        title: title,
        onComplete: () => Navigator.of(context).pop(),
      ),
    );
    return roll;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
          DiceAnimationWidget(
            roll: roll,
            onComplete: onComplete,
            duration: duration,
            size: 150,
          ),
        ],
      ),
    );
  }
}

/// Widget compact pour afficher un résultat de dé (sans animation)
class DiceResultWidget extends StatelessWidget {
  final DiceRoll roll;
  final double size;

  const DiceResultWidget({
    super.key,
    required this.roll,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getDiceColor(),
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${roll.result}',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getDiceColor() {
    switch (roll.resultColor) {
      case DiceResultColor.legendary:
        return Colors.amber;
      case DiceResultColor.epic:
        return Colors.purple;
      case DiceResultColor.rare:
        return Colors.blue;
      case DiceResultColor.common:
        return Colors.green;
      case DiceResultColor.poor:
        return Colors.grey;
      case DiceResultColor.failure:
        return Colors.red.shade900;
    }
  }
}
