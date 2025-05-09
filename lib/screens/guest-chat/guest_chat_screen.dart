
import 'package:flutter/material.dart';

class GuestChatScreen extends StatelessWidget {
  const GuestChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guest Chat")),
      body: const Center(child: Text("This is a public guest chat screen.")),
    );
  }
}
