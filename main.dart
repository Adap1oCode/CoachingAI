import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat/chat_history_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/chatwoot_widget_screen.dart'; // Import ChatwootWidgetScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Application',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,  // Set the initial route to Home screen
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.profile: (context) => ProfileScreen(),
        AppRoutes.chatHistory: (context) => ChatHistoryScreen(),
        AppRoutes.chat: (context) => ChatScreen(),
        AppRoutes.chatwootWidget: (context) => ChatwootWidgetScreen(), // Add Chatwoot Widget route
      },
    );
  }
}
