import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isFromUser;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isFromUser ? Colors.transparent : const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(isFromUser ? 0 : 24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
