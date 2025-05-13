import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/widget/conversation_tile.dart';
import 'package:coaching_ai_new/core/widget/search_conversations_input.dart';
import 'package:coaching_ai_new/core/widget/start_new_chat_button.dart';

class ChatSidebar extends StatefulWidget {
  final List<Map<String, dynamic>> conversations;
  final int? conversationId;
  final Function(int) onSelectConversation;
  final VoidCallback onStartNewConversation;
  final bool showSearch;
  final bool isMobile;
  final bool isLoading;

  const ChatSidebar({
    super.key,
    required this.conversations,
    required this.conversationId,
    required this.onSelectConversation,
    required this.onStartNewConversation,
    this.showSearch = true,
    this.isMobile = false,
    this.isLoading = false,
  });

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  late TextEditingController _searchController;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchTerm.isEmpty) return widget.conversations;
    return widget.conversations.where((convo) {
      final id = convo['conversation_id'].toString();
      final msg = convo['last_message']?.toString().toLowerCase() ?? '';
      return id.contains(_searchTerm) || msg.contains(_searchTerm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showSearch)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 20.0,
                    bottom: 8.0,
                  ),
                  child: SearchConversationsInput(
                    controller: _searchController,
                    onChanged: (val) =>
                        setState(() => _searchTerm = val.toLowerCase()),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StartNewChatButton(
                  onPressed: widget.onStartNewConversation,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: widget.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredConversations.isEmpty
                        ? const Center(child: Text('No conversations found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _filteredConversations.length,
                            itemBuilder: (context, index) {
                              final convo = _filteredConversations[index];
                              final isSelected =
                                  convo['conversation_id'] ==
                                      widget.conversationId;

                              return ConversationTile(
                                conversation: convo,
                                isSelected: isSelected,
                                onTap: () => widget
                                    .onSelectConversation(convo['conversation_id']),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
