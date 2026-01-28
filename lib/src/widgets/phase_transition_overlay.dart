import 'package:flutter/material.dart';

/// Widget pour afficher les transitions de phase style Fire Emblem
class PhaseTransitionOverlay extends StatefulWidget {
  final String message;
  final Color color;
  final Duration duration;

  const PhaseTransitionOverlay({
    super.key,
    required this.message,
    required this.color,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PhaseTransitionOverlay> createState() => _PhaseTransitionOverlayState();

  /// Affiche l'overlay de transition de phase
  static void show({
    required BuildContext context,
    required String message,
    required Color color,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = OverlayEntry(
      builder: (context) => PhaseTransitionOverlay(
        message: message,
        color: color,
        duration: duration,
      ),
    );

    Overlay.of(context).insert(overlay);

    Future.delayed(duration, () {
      overlay.remove();
    });
  }
}

class _PhaseTransitionOverlayState extends State<PhaseTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Animation inverse après 60% du temps
    Future.delayed(Duration(milliseconds: (widget.duration.inMilliseconds * 0.6).round()), () {
      if (mounted) {
        _controller.reverse();
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
      color: Colors.transparent,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.0),
                    widget.color.withOpacity(0.9),
                    widget.color.withOpacity(0.9),
                    widget.color.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.2, 0.8, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
