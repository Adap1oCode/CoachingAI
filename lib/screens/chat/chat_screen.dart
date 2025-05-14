import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/chat/user_chat_service.dart';
import '../../core/widget/auth_screen_scaffold.dart';
import '../../core/widget/chat_input_row.dart';
import '../../core/widget/empty_chat_prompt.dart';
import '../../core/widget/message_bubble.dart';
import '../../core/widget/animated_typing_bubble.dart';
import '../../core/logic/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String? contactId;
  final String? accountId;
  final String? sourceId;
  final String? hmac;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.contactId,
    this.accountId,
    this.sourceId,
    this.hmac,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with ChatController {
  String? _initials;

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] ?? user?.email ?? 'User';
    _initials = getInitials(fullName).toUpperCase();
    print('🧪 ChatScreen resolved initials: $_initials');

    initializeChat(
      service: UserChatService(
        userId: widget.userId,
        contactId: widget.contactId,
        accountId: widget.accountId,
        sourceId: widget.sourceId,
      ),
    );

    loadConversations();
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    return parts.length == 1 ? parts[0][0] : parts[0][0] + parts.last[0];
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      title: "Chat",
      initials: _initials ?? 'U',
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
