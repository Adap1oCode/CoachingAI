import 'package:flutter/material.dart';
import 'package:chatwoot_sdk/chatwoot_sdk.dart';

class ChatwootWidgetScreen extends StatefulWidget {
  final bool guest;

  const ChatwootWidgetScreen({super.key, this.guest = false});

  @override
  State<ChatwootWidgetScreen> createState() => _ChatwootWidgetScreenState();
}

class _ChatwootWidgetScreenState extends State<ChatwootWidgetScreen> {
  @override
  void initState() {
    super.initState();

    ChatwootSDK.init(
      baseUrl: 'https://YOUR-CHATWOOT-URL.com', // Replace this!
      inboxIdentifier: 'YOUR-INBOX-ID',         // Replace this!
      locale: 'en',
    );

    ChatwootSDK.setUser(
      identifier: widget.guest
          ? 'guest_${DateTime.now().millisecondsSinceEpoch}'
          : 'user@example.com',
      name: widget.guest ? 'Guest' : 'John Doe',
      email: widget.guest ? 'guest@example.com' : 'user@example.com',
    );

    // Optional: You can also clear the user with ChatwootSDK.clearUser()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Chat')),
      body: const ChatwootSDKWidget(), // <- ✅ This is the correct widget
    );
  }
}
