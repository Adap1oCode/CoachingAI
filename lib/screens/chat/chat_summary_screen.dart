
import 'package:flutter/material.dart';

class ChatSummaryScreen extends StatelessWidget {
  const ChatSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Summary")),
      body: const Center(child: Text("This is where AI summary is shown.")),
    );
  }
}
