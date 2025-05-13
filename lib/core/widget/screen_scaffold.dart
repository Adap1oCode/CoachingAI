import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/constants/text_styles.dart';
import 'package:coaching_ai_new/core/widget/logo_widget.dart';
import 'package:coaching_ai_new/core/widget/responsive_form_wrapper.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final bool showLogo;

  const ScreenScaffold({
    super.key,
    required this.child,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: ResponsiveFormWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showLogo) const LogoWidget(height: 100),
                if (showLogo) ...[
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.splashSubtitle,
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: height * 0.1),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
