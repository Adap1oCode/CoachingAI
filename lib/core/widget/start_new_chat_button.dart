import 'package:flutter/material.dart';

class StartNewChatButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartNewChatButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: const Text("Start New Chat"),
      ),
    );
  }
}
