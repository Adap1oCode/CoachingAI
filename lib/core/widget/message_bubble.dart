import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isFromGuest;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isFromGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isFromGuest ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isFromGuest ? const Color(0xFFF1F1F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(isFromGuest ? 24 : 0),
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
