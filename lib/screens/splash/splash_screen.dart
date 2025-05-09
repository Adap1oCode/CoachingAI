import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/widget/logo_widget.dart';
import 'package:coaching_ai_new/core/widget/splash_loader.dart';

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

    // Simulate setup tasks or delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const SplashLoader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const LogoWidget(height: 100),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.splashSubtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey[700]),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, RouteNames.login),
                        style: elevatedButtonStyle(),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, RouteNames.register),
                        style: elevatedButtonStyle(),
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, RouteNames.guestChat),
                        style: outlinedButtonStyle(),
                        child: const Text('Continue as Guest'),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
    );
  }
}
