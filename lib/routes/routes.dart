import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/two_factor_screen.dart';
import '../screens/auth/registration_success_screen.dart'; // ✅ NEW
import '../screens/guest_chat/guest_chat_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_history_screen.dart';
import '../screens/chat/chat_summary_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  RouteNames.splash: (context) => const SplashScreen(),
  RouteNames.login: (context) => const LoginScreen(),
  RouteNames.register: (context) => const RegisterScreen(),
  RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(),
  RouteNames.twoFA: (context) => const TwoFactorScreen(),
  RouteNames.registrationSuccess: (context) => const RegistrationSuccessScreen(), // ✅ NEW
  RouteNames.guestChat: (context) => const GuestChatScreen(),
  RouteNames.chat: (context) => const ChatScreen(),
  RouteNames.chatHistory: (context) => const ChatHistoryScreen(),
  RouteNames.chatSummary: (context) => const ChatSummaryScreen(),
  RouteNames.profile: (context) => const ProfileScreen(),
  RouteNames.settings: (context) => const SettingsScreen(),
};
