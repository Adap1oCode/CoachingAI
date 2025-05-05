import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text("Register"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: const Text("Profile"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.chatHistory),
              child: const Text("Chat History"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.chat),
              child: const Text("Live Chat"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.chatwootWidget), // Navigate to the ChatwootWidgetScreen
              child: const Text("Open Chatwoot Widget"),
            ),
          ],
        ),
      ),
    );
  }
}
