import 'package:flutter/material.dart';

class ChatwootWidgetScreen extends StatelessWidget {
  const ChatwootWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatwoot Widget Screen')),
      body: Center(child: Text('Welcome to Chatwoot Widget Screen')),
    );
  }
}
