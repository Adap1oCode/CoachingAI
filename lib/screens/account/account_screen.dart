import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/widget/two_factor_settings_section.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TwoFactorSettingsSection(),
          ],
        ),
      ),
    );
  }
}
