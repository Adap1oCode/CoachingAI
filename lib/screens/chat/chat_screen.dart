import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/chat/chat_service.dart';
import '../../services/chat/user_chat_service.dart';

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

  late final UserChatService _chatService;
  int? _conversationId;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _conversations = [];
  bool _isSending = false;
  bool _hasStartedBefore = false;
  bool _hasStartedChat = false;

  @override
  void initState() {
    super.initState();
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
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts.last[0];
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
                'is_from_guest': msg['is_from_guest'], // Optional
              })
          .cast<Map<String, dynamic>>()
          .toList();

      processed.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      setState(() {
        _conversationId = conversationId;
        _messages = processed;
        _hasStartedChat = true;
      });

      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

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
      _messageController.clear();

      setState(() {
        _conversationId =
            int.tryParse(response['conversation_id']?.toString() ?? '');
        _hasStartedBefore = true;
      });

      await _loadConversations();
      if (_conversationId != null) {
        await _loadConversationMessages(_conversationId!);
      }
    }

    setState(() => _isSending = false);
  }

  void _startNewConversation() {
    setState(() {
      _conversationId = null;
      _messages = [];
      _hasStartedChat = true;
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

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['is_from_guest'] != true;
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          msg['content'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(widget.userName).toUpperCase();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF00BF6D)),
              child: Text(
                widget.userName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {}, // TODO
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Chat History'),
              onTap: () {}, // TODO
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {}, // TODO
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {}, // TODO
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Chat"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xFF00BF6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _conversations.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("New Chat"),
                    onTap: _startNewConversation,
                    tileColor: Colors.green.shade50,
                  );
                }

                final convo = _conversations[index - 1];
                return ListTile(
                  title: Text("Conversation #${convo['conversation_id']}"),
                  subtitle: Text(convo['last_message'] ?? ''),
                  onTap: () =>
                      _loadConversationMessages(convo['conversation_id']),
                  selected: convo['conversation_id'] == _conversationId,
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _hasStartedChat
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(width: 12),
                            const Icon(Icons.tune),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  filled: true,
                                  fillColor:
                                      const Color(0xFF00BF6D).withOpacity(0.08),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 12.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.mic),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _sendMessage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton.icon(
                      onPressed: _startNewConversation,
                      icon: const Icon(Icons.chat),
                      label: const Text("Start New Chat"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
