import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/core/widget/logo_widget.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(height: 100),
                  const SizedBox(height: 40),
                  Text(
                    'Registration Complete',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Check your email to verify your account before logging in.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RouteNames.login);
                    },
                    style: elevatedButtonStyle(),
                    child: const Text(AppStrings.signIn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
