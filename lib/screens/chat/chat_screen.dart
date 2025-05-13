import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/route_names.dart';
import '../../services/chat/user_chat_service.dart';
import '../../services/chat/chat_service.dart';
import '../../core/widget/auth_screen_scaffold.dart';
import '../../core/widget/chat_input_row.dart';
import '../../core/widget/empty_chat_prompt.dart';
import '../../core/widget/message_bubble.dart';
import '../../core/widget/animated_typing_bubble.dart';

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

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  late final UserChatService _chatService;
  int? _conversationId;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _conversations = [];
  bool _isSending = false;
  bool _hasStartedChat = false;
  bool _isTyping = false;
  String? _initials; // ✅ Memoized initials

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] ?? user?.email ?? 'User';
    _initials = getInitials(fullName).toUpperCase();
    print('🧪 ChatScreen resolved initials: $_initials');

    _chatService = UserChatService(
      userId: widget.userId,
      contactId: widget.contactId,
      accountId: widget.accountId,
      sourceId: widget.sourceId,
    );

    _loadConversations();
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    return parts.length == 1 ? parts[0][0] : parts[0][0] + parts.last[0];
  }

  Future<void> _loadConversations() async {
    if (widget.contactId == null) return;
    final list = await _chatService.getConversations();
    final patched = list.map((conv) => {
      ...conv,
      'last_message': 'Tap to open this conversation',
    }).toList();
    setState(() => _conversations = patched);
  }

  Future<void> _loadConversationMessages(int conversationId) async {
    final result = await _chatService.getMessages(conversationId.toString());
    if (result != null && result['messages'] is List) {
      final rawMessages = result['messages'] as List;
      final processed = rawMessages.map((msg) => {
        'id': msg['id'],
        'content': msg['content'],
        'is_from_user': msg['is_from_user'] ?? false,
      }).cast<Map<String, dynamic>>().toList();
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
        'is_from_user': true,
      });
      _messageController.clear();
    });

    _scrollToBottom();

    final eventType = _conversationId == null
        ? (_conversations.isEmpty
            ? ChatEventType.initialAccountChat
            : ChatEventType.newConversation)
        : ChatEventType.newMessage;

    final response = await _chatService.sendMessage(
      content: content,
      eventType: eventType,
      conversationId: _conversationId?.toString(),
    );

    if (response != null && response['event'] == 'message_created') {
      setState(() => _conversationId = int.tryParse(response['conversation_id']?.toString() ?? ''));
      await _loadConversations();
      if (_conversationId != null) {
        await _loadConversationMessages(_conversationId!);
      }
    } else {
      setState(() => _isTyping = false);
    }

    setState(() => _isSending = false);
    Future.delayed(const Duration(milliseconds: 150), () {
      _inputFocusNode.requestFocus();
    });
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

  void _summarizeChat() {
    print('Summary button tapped');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      title: "Chat",
      initials: _initials ?? 'U', // ✅ safe fallback
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
                      if (_isTyping && index == _messages.length) {
                        return const AnimatedTypingBubble();
                      }
                      final msg = _messages[index];
                      return MessageBubble(
                        content: msg['content'] ?? '',
                        isFromUser: msg['is_from_user'] == true,
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
                  showSummarize: true,
                  onSummarize: _summarizeChat,
                ),
              ],
            )
          : EmptyChatPrompt(onPressed: _startNewConversation),
    );
  }
}
