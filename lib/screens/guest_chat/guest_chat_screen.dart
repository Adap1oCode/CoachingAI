import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/chat/chat_service.dart';
import '../../services/chat/guest_chat_service.dart';
import '../../core/utils/form_decorators.dart';
import '../../core/utils/button_styles.dart';
import '../../core/widget/empty_chat_prompt.dart';
import '../../core/widget/message_bubble.dart';
import '../../core/widget/chat_input_row.dart';
import '../../core/widget/animated_typing_bubble.dart';
import '../../core/widget/auth_screen_scaffold.dart';

class GuestChatScreen extends StatefulWidget {
  const GuestChatScreen({super.key});

  @override
  State<GuestChatScreen> createState() => _GuestChatScreenState();
}

class _GuestChatScreenState extends State<GuestChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  late final GuestChatService _chatService;
  int? _conversationId;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _conversations = [];
  bool _isSending = false;
  bool _hasStartedBefore = false;
  bool _hasStartedChat = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chatService = GuestChatService();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final list = await _chatService.getConversations();
    final patchedList = list.map((conv) => {
      ...conv,
      'last_message': 'Tap to open this conversation',
    }).toList();

    setState(() => _conversations = patchedList);
  }

  Future<void> _loadConversationMessages(int conversationId) async {
    final result = await _chatService.getMessages(conversationId.toString());
    if (result != null && result['messages'] is List) {
      final rawMessages = result['messages'] as List<dynamic>;
      final processed = rawMessages
          .map((msg) => {
                'id': msg['id'],
                'content': msg['content'],
                'is_from_guest': msg['is_from_guest'],
              })
          .cast<Map<String, dynamic>>()
          .toList();

      processed.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      setState(() {
        _conversationId = conversationId;
        _messages = processed;
        _hasStartedChat = true;
        _isTyping = false;
      });

      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _isTyping = true;

      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': content,
        'is_from_guest': true,
      });

      _messageController.clear();
    });

    _scrollToBottom();

    final eventType = _conversationId == null
        ? (_hasStartedBefore
            ? ChatEventType.newConversation
            : ChatEventType.firstConversation)
        : ChatEventType.newMessage;

    final response = await _chatService.sendMessage(
      content: content,
      eventType: eventType,
      conversationId: _conversationId?.toString(),
    );

    if (response != null && response['event'] == 'message_created') {
      final newId = int.tryParse(response['conversation_id']?.toString() ?? '');
      setState(() {
        _conversationId = newId;
        _hasStartedBefore = true;
      });

      await _loadConversations();
      if (_conversationId != null) {
        await _loadConversationMessages(_conversationId!);
      }
    } else {
      setState(() => _isTyping = false);
    }

    setState(() => _isSending = false);
  }

  void _startNewConversation() {
    setState(() {
      _conversationId = null;
      _messages = [];
      _hasStartedChat = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _inputFocusNode.requestFocus();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      title: 'Guest Chat',
      initials: 'GU',
      conversations: _conversations,
      conversationId: _conversationId,
      onStartNewConversation: _startNewConversation,
      onSelectConversation: _loadConversationMessages,
      child: _hasStartedChat
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return const AnimatedTypingBubble();
                      }
                      final msg = _messages[index];
                      return MessageBubble(
                        content: msg['content'] ?? '',
                        isFromGuest: msg['is_from_guest'] == true,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ChatInputRow(
                  controller: _messageController,
                  onSend: _sendMessage,
                  isSending: _isSending,
                  focusNode: _inputFocusNode,
                ),
              ],
            )
          : EmptyChatPrompt(onPressed: _startNewConversation),
    );
  }
}
