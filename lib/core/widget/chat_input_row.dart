import 'package:flutter/material.dart';

class ChatInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final FocusNode focusNode;
  final VoidCallback? onSummarize;
  final bool showSummarize;

  const ChatInputRow({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isSending,
    required this.focusNode,
    this.onSummarize,
    this.showSummarize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (showSummarize && onSummarize != null) ...[
            IconButton(
              icon: const Icon(Icons.auto_awesome, color: Colors.black),
              onPressed: onSummarize,
            ),
            const SizedBox(width: 12),
          ],

          const Icon(Icons.add),
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

          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: isSending ? null : onSend,
            ),
          ),
        ],
      ),
    );
  }
}
