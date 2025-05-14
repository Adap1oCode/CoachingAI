import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/widget/auth_screen_scaffold.dart';
import 'package:coaching_ai_new/core/widget/chat_input_row.dart';
import 'package:coaching_ai_new/core/widget/empty_chat_prompt.dart';
import 'package:coaching_ai_new/core/widget/message_bubble.dart';
import 'package:coaching_ai_new/core/widget/animated_typing_bubble.dart';
import 'package:coaching_ai_new/services/chat/guest_chat_service.dart';
import 'package:coaching_ai_new/core/logic/chat_controller.dart';

class GuestChatScreen extends StatefulWidget {
  const GuestChatScreen({super.key});

  @override
  State<GuestChatScreen> createState() => _GuestChatScreenState();
}

class _GuestChatScreenState extends State<GuestChatScreen> with ChatController {
  @override
  void initState() {
    super.initState();
    initializeChat(service: GuestChatService());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      title: "Guest Chat",
      initials: "G",
      conversations: conversations,
      conversationId: conversationId,
      onStartNewConversation: startNewConversation,
      onSelectConversation: loadConversationMessages,
      child: hasStartedChat
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isTyping && index == messages.length) {
                        return const AnimatedTypingBubble();
                      }
                      final msg = messages[index];
                      return MessageBubble(
                        content: msg['content'] ?? '',
                        isFromUser: msg['is_from_user'] == true,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ChatInputRow(
                  controller: messageController,
                  onSend: sendMessage,
                  isSending: isSending,
                  focusNode: inputFocusNode,
                  showSummarize: true,
                  onSummarize: summarizeChat,
                ),
              ],
            )
          : EmptyChatPrompt(onPressed: startNewConversation),
    );
  }
}
