import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/animation_state.dart';

/// Widget avancé pour animer des sprites de combat avec différents états
/// (idle, attack, hit, death, victory)
class CombatAnimatedSprite extends StatefulWidget {
  final AnimationSet animationSet;
  final AnimationState currentState;
  final double width;
  final double height;
  final bool isSelected;
  final bool flipHorizontal; // Pour faire face à l'opposant
  final Widget Function()? fallbackBuilder;
  final VoidCallback? onAnimationComplete; // Callback quand l'animation se termine (pour non-loop)

  const CombatAnimatedSprite({
    super.key,
    required this.animationSet,
    required this.currentState,
    required this.width,
    required this.height,
    this.isSelected = false,
    this.flipHorizontal = false,
    this.fallbackBuilder,
    this.onAnimationComplete,
  });

  @override
  State<CombatAnimatedSprite> createState() => _CombatAnimatedSpriteState();
}

class _CombatAnimatedSpriteState extends State<CombatAnimatedSprite> {
  int _currentFrame = 0;
  Timer? _animationTimer;
  bool _hasError = false;
  AnimationConfig? _currentAnimation;

  @override
  void initState() {
    super.initState();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(CombatAnimatedSprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si l'état d'animation change, réinitialiser l'animation
    if (oldWidget.currentState != widget.currentState) {
      _currentFrame = 0;
      _updateAnimation();
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _updateAnimation() {
    _animationTimer?.cancel();
    _currentAnimation = widget.animationSet.getAnimation(widget.currentState);
    
    if (_currentAnimation != null) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_currentAnimation == null) return;

    _animationTimer = Timer.periodic(_currentAnimation!.frameDuration, (timer) {
      if (mounted && !_hasError) {
        setState(() {
          _currentFrame++;
          
          // Si on atteint la fin de l'animation
          if (_currentFrame >= _currentAnimation!.frameCount) {
            if (_currentAnimation!.loop) {
              // Loop: revenir au début
              _currentFrame = 0;
            } else {
              // Non-loop: rester sur la dernière frame et notifier
              _currentFrame = _currentAnimation!.frameCount - 1;
              _animationTimer?.cancel();
              widget.onAnimationComplete?.call();
            }
          }
        });
      }
    });
  }

  void _onImageError() {
    if (mounted && !_hasError) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _animationTimer?.cancel();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si pas d'animation ou erreur, utiliser le fallback
    if (_currentAnimation == null || _hasError) {
      return widget.fallbackBuilder?.call() ?? const SizedBox.shrink();
    }

    Widget spriteWidget = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isSelected ? Colors.yellow : Colors.transparent,
          width: widget.isSelected ? 3 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1.0 / _currentAnimation!.frameCount,
          child: Transform.translate(
            offset: Offset(-widget.width * _currentFrame, 0),
            child: Image.asset(
              _currentAnimation!.assetPath,
              width: widget.width * _currentAnimation!.frameCount,
              height: widget.height,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none, // Pixel art sans lissage
              errorBuilder: (context, error, stackTrace) {
                _onImageError();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    // Appliquer le flip horizontal si nécessaire
    if (widget.flipHorizontal) {
      spriteWidget = Transform.flip(
        flipX: true,
        child: spriteWidget,
      );
    }

    return spriteWidget;
  }
}
