import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDuration;
  final VoidCallback? onComplete;
  final bool allowFastForward;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDuration = const Duration(milliseconds: 24),
    this.onComplete,
    this.allowFastForward = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  int _count = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer = Timer.periodic(widget.charDuration, (_) {
      if (!mounted) return;
      setState(() {
        _count++;
        if (_count >= widget.text.length) {
          _finished = true;
          _timer?.cancel();
          widget.onComplete?.call();
        }
      });
    });
  }

  void fastForward() {
    if (!_finished && widget.allowFastForward) {
      setState(() {
        _count = widget.text.length;
        _finished = true;
      });
      _timer?.cancel();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(0, _count.clamp(0, widget.text.length));
    return GestureDetector(
      onTap: fastForward,
      child: Text(
        visible,
        style: widget.style,
      ),
    );
  }
}
