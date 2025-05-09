import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Placeholder for authenticated user's name
  final String userName = "Kalim Mukhtar";

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts.last[0];
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(userName).toUpperCase();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF00BF6D),
              ),
              child: Text(
                userName,
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
      body: const Center(
        child: Text("Authenticated Chat UI goes here."),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 12),
            const Icon(Icons.tune),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: const Color(0xFF00BF6D).withOpacity(0.08),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.mic),
            const SizedBox(width: 12),
            const Icon(Icons.send),
          ],
        ),
      ),
    );
  }
}
