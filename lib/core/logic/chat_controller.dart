import 'package:flutter/material.dart';
import 'package:coaching_ai_new/services/chat_service.dart';

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
                'is_from_guest': msg['is_from_guest'],
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

  // Optional: override this in screen if needed (like in guest chat)
  Future<void> sendMessage() async {}
}
