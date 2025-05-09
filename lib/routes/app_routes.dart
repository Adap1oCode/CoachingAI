import 'package:flutter/material.dart';
import '../screens/core/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/chat/chatwoot_widget_screen.dart'; // ✅ Import added

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const chat = '/chat';
  static const chatHistory = '/chat-history';
  static const profile = '/profile';
  static const chatwootWidget = '/chatwoot-widget'; // ✅ Route constant

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    home: (context) => const HomeScreen(),
    chat: (context) => const ChatScreen(),
    chatHistory: (context) => const ChatHistoryScreen(),
    profile: (context) => const ProfileScreen(),
    chatwootWidget: (context) => const ChatwootWidgetScreen(), // ✅ Route added
  };
}
