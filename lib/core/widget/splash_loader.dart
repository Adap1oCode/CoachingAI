import 'package:flutter/material.dart';
import 'logo_widget.dart';

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _dots;
  int _dotIndex = 0;

  @override
  void initState() {
    super.initState();
    _dots = ['', '.', '..', '...'];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reset();
          setState(() {
            _dotIndex = (_dotIndex + 1) % _dots.length;
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: const LogoWidget(height: 80),
          ),
          const SizedBox(height: 32),
          Text(
            'Loading${_dots[_dotIndex]}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
