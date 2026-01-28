import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Widget pour animer un sprite sheet de pixel art (style Fire Emblem)
/// Le sprite sheet doit contenir plusieurs frames alignées horizontalement
class AnimatedPixelSprite extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final int frameCount;
  final Duration frameDuration;
  final bool isSelected;
  final Widget Function()? fallbackBuilder;

  const AnimatedPixelSprite({
    super.key,
    required this.assetPath,
    required this.width,
    required this.height,
    this.frameCount = 8,
    this.frameDuration = const Duration(milliseconds: 150),
    this.isSelected = false,
    this.fallbackBuilder,
  });

  @override
  State<AnimatedPixelSprite> createState() => _AnimatedPixelSpriteState();
}

class _AnimatedPixelSpriteState extends State<AnimatedPixelSprite> {
  int _currentFrame = 0;
  Timer? _animationTimer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(widget.frameDuration, (timer) {
      if (mounted && !_hasError) {
        setState(() {
          _currentFrame = (_currentFrame + 1) % widget.frameCount;
        });
      }
    });
  }

  void _onImageError() {
    if (mounted && !_hasError) {
      // Reporter le setState après le build actuel
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
    // Si erreur, retourner directement le fallback sans style
    if (_hasError) {
      return widget.fallbackBuilder?.call() ?? const SizedBox.shrink();
    }

    return Container(
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
          widthFactor: 1.0 / widget.frameCount,
          child: Transform.translate(
            offset: Offset(-widget.width * _currentFrame, 0),
            child: Image.asset(
              widget.assetPath,
              width: widget.width * widget.frameCount,
              height: widget.height,
              fit: BoxFit.contain, // Contenir l'image dans la zone
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
  }
}
