import 'package:flutter/material.dart';
import 'package:coaching_ai_new/services/chat/chat_service.dart';

mixin ChatController<T extends StatefulWidget> on State<T> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();

  late IChatService chatService;
  int? conversationId;

  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> conversations = [];
  bool isSending = false;
  bool isTyping = false;
  bool hasStartedChat = false;

  String? summary;
  bool showSummaryPopup = false;

  void initializeChat({required IChatService service}) {
    chatService = service;
  }

  Future<void> loadConversations() async {
    final list = await chatService.getConversations();
    final patchedList = list
        .map((conv) => {
              ...conv,
              'last_message': 'Tap to open this conversation',
            })
        .toList();

    setState(() => conversations = patchedList);
  }

  Future<void> loadConversationMessages(int convId) async {
    final result = await chatService.getMessages(convId.toString());
    if (result != null && result['messages'] is List) {
      final rawMessages = result['messages'] as List;

      final processed = rawMessages
          .map((msg) => {
                'id': msg['id'],
                'content': msg['content'],
                'is_from_user': msg['is_from_user'] ?? msg['is_from_guest'] ?? false,
              })
          .cast<Map<String, dynamic>>()
          .toList();

      processed.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

      setState(() {
        conversationId = convId;
        messages = processed;
        hasStartedChat = true;
        isTyping = false;
      });

      scrollToBottom();
      inputFocusNode.requestFocus();
    }
  }

  void startNewConversation() {
    setState(() {
      conversationId = null;
      messages = [];
      hasStartedChat = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      inputFocusNode.requestFocus();
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> summarizeChat() async {
    final allText = messages.map((m) => m['content']).join('\n');
    final generated = 'Summary: ${allText.substring(0, allText.length.clamp(0, 200))}...';

    setState(() {
      summary = generated;
      showSummaryPopup = true;
    });
  }

  
  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty || isSending) return;

    setState(() {
      isSending = true;
      isTyping = true;
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': content,
        'is_from_user': true,
      });
      messageController.clear();
    });

    scrollToBottom();

    final eventType = conversationId == null
        ? (conversations.isEmpty
            ? ChatEventType.firstConversation
            : ChatEventType.newConversation)
        : ChatEventType.newMessage;

    final response = await chatService.sendMessage(
      content: content,
      eventType: eventType,
      conversationId: conversationId?.toString(),
    );

    if (response != null && response['event'] == 'message_created') {
      final newId = int.tryParse(response['conversation_id']?.toString() ?? '');
      setState(() {
        conversationId = newId;
      });

      await loadConversations();
      if (conversationId != null) {
        await loadConversationMessages(conversationId!);
      }
    } else {
      setState(() => isTyping = false);
    }

    setState(() => isSending = false);

    Future.delayed(const Duration(milliseconds: 150), () {
      inputFocusNode.requestFocus();
    });
  }
}
