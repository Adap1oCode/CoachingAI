import 'package:flutter/material.dart';

class ChatSummaryScreen extends StatelessWidget {
  const ChatSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChatSummary> summaries = [
      ChatSummary(
        title: "Client Onboarding Call",
        subtitle: "Key takeaways and next steps discussed...",
        time: "2h ago",
      ),
      ChatSummary(
        title: "Sales Demo with Omar",
        subtitle: "Product feedback and trial plan...",
        time: "Yesterday",
      ),
      ChatSummary(
        title: "Internal Strategy Discussion",
        subtitle: "Focus on Q3 goals and execution...",
        time: "3d ago",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chat Summaries"),
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: summaries.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final summary = summaries[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              summary.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                summary.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Text(
              summary.time,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            onTap: () {
              // TODO: Navigate to detailed summary
            },
          );
        },
      ),
    );
  }
}

class ChatSummary {
  final String title;
  final String subtitle;
  final String time;

  ChatSummary({
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
