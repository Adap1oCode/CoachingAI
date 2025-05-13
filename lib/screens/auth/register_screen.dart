import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/core/widget/logo_widget.dart';
import 'package:coaching_ai_new/core/widget/back_button_widget.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/utils/validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coaching_ai_new/config/app_config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = '';
  String email = '';
  String password = '';
  bool loading = false;
  String? error;
  bool _obscurePassword = true;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      // 1. Register user with Supabase
      final user = await _authService.signUp(
        email: email.trim(),
        password: password.trim(),
        name: name.trim(),
      );

      final userId = user.id;

      // 2. Send user info to n8n (to create Chatwoot contact)
      try {
        await http.post(
          Uri.parse(Env.registrationWebhookUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'full_name': name.trim(),
            'user_id': userId,
          }),
        );
      } catch (e) {
        debugPrint('n8n webhook failed: $e');
      }

      // 3. Notify and redirect
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created! Check your email to verify."),
          ),
        );
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const LogoWidget(height: 100),
                  SizedBox(height: constraints.maxHeight * 0.08),
                  Text(
                    AppStrings.registerTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: inputDecoration(AppStrings.fullName),
                              textInputAction: TextInputAction.next,
                              onChanged: (val) => name = val,
                              validator: (val) =>
                                  val == null || val.isEmpty
                                      ? AppStrings.nameRequired
                                      : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: inputDecoration(AppStrings.email),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) => email = val,
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration:
                                  inputDecoration(AppStrings.password).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _register(),
                              onChanged: (val) => password = val,
                              validator: validatePassword,
                            ),
                            const SizedBox(height: 24),
                            if (loading) const CircularProgressIndicator(),
                            if (error != null) ...[
                              const SizedBox(height: 8),
                              Text(error!,
                                  style:
                                      const TextStyle(color: Colors.red)),
                            ],
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: loading ? null : _register,
                              style: elevatedButtonStyle(),
                              child: Text(AppStrings.register),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, RouteNames.login),
                              child: Text(AppStrings.alreadyHaveAccount +
                                  AppStrings.signIn),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
