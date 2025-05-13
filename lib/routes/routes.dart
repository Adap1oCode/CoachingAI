import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/two_factor_screen.dart';
import '../screens/auth/registration_success_screen.dart';
import '../screens/auth/callback_screen.dart';
import '../screens/guest_chat/guest_chat_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_history_screen.dart';
import '../screens/chat/chat_summary_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../core/widget/auth_screen_scaffold.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/edit_profile_screen.dart';
import '../screens/auth/logout_screen.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case RouteNames.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case RouteNames.register:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    case RouteNames.forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    case RouteNames.twoFA:
      return MaterialPageRoute(builder: (_) => const TwoFactorScreen());
    case RouteNames.registrationSuccess:
      return MaterialPageRoute(builder: (_) => const RegistrationSuccessScreen());
    case RouteNames.callback:
      return MaterialPageRoute(builder: (_) => const CallbackScreen());
    case RouteNames.guestChat:
      return MaterialPageRoute(builder: (_) => const GuestChatScreen());
    case RouteNames.chat:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => ChatScreen(
          userId: args['userId'],
          userName: args['userName'],
          contactId: args['contactId'],
          accountId: args['accountId'],
          sourceId: args['sourceId'],
          hmac: args['hmac'],
        ),
      );
    case RouteNames.chatHistory:
      return MaterialPageRoute(builder: (_) => const ChatHistoryScreen());
    case RouteNames.chatSummary:
      return MaterialPageRoute(builder: (_) => const ChatSummaryScreen());
    case RouteNames.profile:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case RouteNames.settings:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    case RouteNames.account:
      return MaterialPageRoute(
        builder: (_) => AuthScreenScaffold(
          title: 'Account',
          initials: 'GU',
          conversations: const [],
          conversationId: null,
          onStartNewConversation: () {},
          onSelectConversation: (_) {},
          child: const AccountScreen(),
        ),
      );
    case RouteNames.editProfile:
  return MaterialPageRoute(builder: (_) => const EditProfileScreen());

case RouteNames.logout:
  return MaterialPageRoute(builder: (_) => const LogoutScreen());
default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Route not found')),
        ),
      );
  }
}
