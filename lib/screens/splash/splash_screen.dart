import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/constants/spacing.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/widget/screen_scaffold.dart';
import 'package:coaching_ai_new/constants/text_styles.dart'; // adjust path if needed


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ScreenScaffold(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.welcomeTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.login),
                    style: elevatedButtonStyle(),
                    child: Text(
                      AppStrings.signIn,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.register),
                    style: elevatedButtonStyle(),
                    child: Text(
                      AppStrings.register,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
  onPressed: () =>
      Navigator.pushNamed(context, RouteNames.guestChat),
  style: outlinedButtonStyle(),
  child: Text(
    AppStrings.continueAsGuest,
    style: AppTextStyles.guestButtonTextStyle(context),
  ),
),
                ],
              ),
            ),
    );
  }
}
