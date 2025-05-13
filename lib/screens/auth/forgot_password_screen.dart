import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/core/utils/validators.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';
import 'package:coaching_ai_new/core/widget/back_button_widget.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  bool sent = false;
  String? error;

  void _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      error = null;
      sent = false;
    });

    try {
      await _authService.sendPasswordReset(email.trim());

      if (mounted) {
        setState(() => sent = true);
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButtonWidget(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                AppStrings.forgotPasswordTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.forgotPasswordSubtext,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: inputDecoration(AppStrings.email),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onChanged: (val) => email = val,
                          validator: validateEmail,
                          onFieldSubmitted: (_) => _sendResetLink(),
                        ),
                        const SizedBox(height: 16),
                        if (sent)
                          const Text(
                            'Password reset email sent. Check your inbox!',
                            style: TextStyle(color: Colors.green),
                          ),
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _sendResetLink,
                          style: elevatedButtonStyle(),
                          child: const Text(AppStrings.sendAgain),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
