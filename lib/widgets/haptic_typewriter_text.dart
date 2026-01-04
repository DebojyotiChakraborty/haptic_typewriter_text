import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticTypewriterController extends ChangeNotifier {
  String _targetText = '';

  void type(String text) {
    _targetText = text;
    notifyListeners();
  }

  void reset() {
    _targetText = '';
    notifyListeners();
  }
}

class HapticTypewriterText extends StatefulWidget {
  final HapticTypewriterController controller;
  final TextStyle? style;
  final Duration speed;
  final VoidCallback? onComplete;

  const HapticTypewriterText({
    super.key,
    required this.controller,
    this.style,
    this.speed = const Duration(milliseconds: 100),
    this.onComplete,
  });

  @override
  State<HapticTypewriterText> createState() => _HapticTypewriterTextState();
}

class _HapticTypewriterTextState extends State<HapticTypewriterText> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;
  String _fullText = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    _timer?.cancel();
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.controller._targetText.isNotEmpty) {
      _startTyping(widget.controller._targetText);
    } else {
      _reset();
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _displayedText = '';
      _currentIndex = 0;
      _fullText = '';
    });
  }

  void _startTyping(String text) {
    _reset();
    _fullText = text;

    _timer = Timer.periodic(widget.speed, (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_currentIndex];
          _currentIndex++;
        });
        HapticFeedback.selectionClick(); // Haptic feedback on every character
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
