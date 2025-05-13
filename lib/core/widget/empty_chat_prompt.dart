import 'package:flutter/material.dart';

class EmptyChatPrompt extends StatelessWidget {
  final VoidCallback onPressed;

  const EmptyChatPrompt({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: const StadiumBorder(),
          ),
          child: const Text("Start New Chat"),
        ),
      ),
    );
  }
}
