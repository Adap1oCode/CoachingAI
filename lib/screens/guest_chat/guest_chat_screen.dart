import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../services/chat_service.dart';

class GuestChatScreen extends StatefulWidget {
  const GuestChatScreen({super.key});

  @override
  State<GuestChatScreen> createState() => _GuestChatScreenState();
}

class _GuestChatScreenState extends State<GuestChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _guestUserId;
  int? _conversationId;
  String? _contactId;
  String? _accountId;
  String? _sourceId; // ✅ NEW: source_id tracking

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _conversations = [];
  bool _isSending = false;
  bool _hasStartedBefore = false;
  bool _hasStartedChat = false;

  @override
  void initState() {
    super.initState();
    _guestUserId = "guest_${const Uuid().v4()}";
  }

  Future<void> _loadConversations() async {
    if (_contactId == null) return;

    final list = await ChatService.getConversations(_contactId!);

    final patchedList = list.map((conv) => {
          ...conv,
          'last_message': 'Tap to open this conversation',
        }).toList();

    setState(() => _conversations = patchedList);
  }

  Future<void> _loadConversationMessages(int conversationId) async {
    final result = await ChatService.getMessages(conversationId.toString());
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
      });

      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final eventType = _conversationId == null
        ? (_hasStartedBefore ? 'new_conversation' : 'first_conversation')
        : 'new_message';

    final response = await ChatService.sendMessage(
      _conversationId?.toString(),
      content,
      _guestUserId,
      eventType,
      contactId: _contactId,
      accountId: _accountId,
      sourceId: _sourceId, // ✅ Send source_id to backend
    );

    if (response != null && response['event'] == 'message_created') {
      _messageController.clear();

      if (response['contact_id'] != null) {
        setState(() {
          _contactId = response['contact_id'].toString();
        });
      }

      if (response['account_id'] != null) {
        setState(() {
          _accountId = response['account_id'].toString();
        });
      }

      if (response['source_id'] != null) {
        setState(() {
          _sourceId = response['source_id'].toString(); // ✅ Store source_id
        });
      }

      if (response['conversation_id'] != null) {
        setState(() {
          _conversationId =
              int.tryParse(response['conversation_id'].toString());
          _hasStartedBefore = true;
        });
      }

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
    final isGuest = msg['is_from_guest'] == true;
    return Container(
      alignment: isGuest ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isGuest ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          msg['content'] ?? '',
          style: TextStyle(color: isGuest ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Chat"),
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _conversations.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("New Chat"),
                    onTap: _startNewConversation,
                    tileColor: Colors.blue.shade50,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
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
