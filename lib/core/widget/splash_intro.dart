import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/constants/spacing.dart';
import 'package:coaching_ai_new/constants/text_styles.dart';
import 'logo_widget.dart';

class SplashIntro extends StatelessWidget {
  const SplashIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LogoWidget(height: 100),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.splashSubtitle, // e.g. "AI-powered support assistant"
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
