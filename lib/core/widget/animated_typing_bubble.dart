import 'package:flutter/material.dart';

class AnimatedTypingBubble extends StatefulWidget {
  const AnimatedTypingBubble({super.key});

  @override
  State<AnimatedTypingBubble> createState() => _AnimatedTypingBubbleState();
}

class _AnimatedTypingBubbleState extends State<AnimatedTypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<String> _dots;
  int _dotIndex = 0;

  @override
  void initState() {
    super.initState();
    _dots = ['', '.', '..', '...'];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          setState(() {
            _dotIndex = (_dotIndex + 1) % _dots.length;
          });
          _controller.forward();
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
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          'Typing${_dots[_dotIndex]}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
