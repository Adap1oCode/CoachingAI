import 'package:flutter/material.dart';

class ChatInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final FocusNode focusNode;

  const ChatInputRow({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isSending,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.add),
          const SizedBox(width: 12),
          const Icon(Icons.tune),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: const Color(0xFF00BF6D).withOpacity(0.08),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.mic),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isSending ? null : onSend,
          ),
        ],
      ),
    );
  }
}
