import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/widget/chat_sidebar.dart';
import 'package:coaching_ai_new/core/widget/chat_app_bar.dart';

class AuthScreenScaffold extends StatelessWidget {
  final String title;
  final String initials;
  final Widget child;
  final List<Map<String, dynamic>> conversations;
  final int? conversationId;
  final VoidCallback onStartNewConversation;
  final void Function(int conversationId) onSelectConversation;

  const AuthScreenScaffold({
    super.key,
    required this.title,
    required this.initials,
    required this.child,
    required this.conversations,
    required this.conversationId,
    required this.onStartNewConversation,
    required this.onSelectConversation,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: isMobile
          ? Drawer(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ChatSidebar(
                conversations: conversations,
                conversationId: conversationId,
                onStartNewConversation: onStartNewConversation,
                onSelectConversation: onSelectConversation,
              ),
            )
          : null,
      appBar: ChatAppBar(
        title: title,
        initials: initials,
        onMenuTap: isMobile ? () => scaffoldKey.currentState?.openDrawer() : null,
      ),
      body: Row(
        children: [
          if (!isMobile)
            SizedBox(
              width: 250,
              child: ChatSidebar(
                conversations: conversations,
                conversationId: conversationId,
                onStartNewConversation: onStartNewConversation,
                onSelectConversation: onSelectConversation,
              ),
            ),
          if (!isMobile) const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
