import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coaching_ai_new/constants/route_names.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _logout(context); // sign out as soon as screen loads
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
