import 'dart:async';
import 'package:flutter/material.dart';
import 'typewriter_text.dart';

class DialogueLine {
  final String speaker;
  final String text;
  final String? portrait; // emoji or asset path
  final List<DialogueChoice>? choices;

  DialogueLine({
    required this.speaker,
    required this.text,
    this.portrait,
    this.choices,
  });
}

class DialogueChoice {
  final String id;
  final String label;
  DialogueChoice({required this.id, required this.label});
}

/// Styled dialogue box inspired by classic SRPG windows (Fire Emblem-like)
class DialogueBox extends StatefulWidget {
  final DialogueLine line;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final ValueChanged<String>? onChoiceSelected;
  final TextStyle? textStyle;
  final Duration charDuration; // vitesse de la machine à écrire
  final bool autoAdvance; // si true, avance automatiquement après autoAdvanceDelay
  final Duration autoAdvanceDelay;

  const DialogueBox({
    super.key,
    required this.line,
    this.onNext,
    this.onSkip,
    this.onChoiceSelected,
    this.textStyle,
    this.charDuration = const Duration(milliseconds: 24),
    this.autoAdvance = false,
    this.autoAdvanceDelay = const Duration(milliseconds: 800),
  });

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> with SingleTickerProviderStateMixin {
  bool _textComplete = false;
  late final AnimationController _appearCtrl;
  Timer? _autoAdvanceTimer;

  void _onComplete() {
    if (!mounted) return;
    setState(() => _textComplete = true);

    if (widget.autoAdvance && widget.onNext != null) {
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer = Timer(widget.autoAdvanceDelay, () {
        if (mounted) widget.onNext?.call();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _appearCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _appearCtrl.forward();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _appearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: CurvedAnimation(parent: _appearCtrl, curve: Curves.easeOut),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background sprite (large, semi-transparent) if portrait is an asset path
          if (widget.line.portrait != null && widget.line.portrait!.contains('/'))
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: 0.12,
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      alignment: Alignment.centerLeft,
                      child: Image.asset(widget.line.portrait!, fit: BoxFit.contain, alignment: Alignment.centerLeft, errorBuilder: (_, __, ___) => const SizedBox()),
                    ),
                  ),
                ),
              ),
            ),

          // Skip button top-right
          Positioned(
            right: 8,
            top: -8,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: TextButton(
                  onPressed: widget.onSkip ?? widget.onNext,
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), backgroundColor: Colors.black45, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Skip', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),

          // Dialogue panel aligned to bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF083049), Color(0xFF0B2A3D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name ribbon
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.line.speaker, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),

                  // Typewriter text
                  TypewriterText(
                    text: widget.line.text,
                    style: widget.textStyle ?? const TextStyle(color: Colors.white, fontSize: 16, height: 1.25),
                    charDuration: widget.charDuration,
                    onComplete: _onComplete,
                  ),

                  const SizedBox(height: 10),

                  // Choices or next arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_textComplete && (widget.line.choices?.isNotEmpty ?? false))
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.line.choices!.map((c) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => widget.onChoiceSelected?.call(c.id),
                                child: Text(c.label),
                              );
                            }).toList(),
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(_textComplete ? Icons.arrow_forward_ios : Icons.play_arrow, color: Colors.white70),
                          onPressed: _textComplete ? widget.onNext : null,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
