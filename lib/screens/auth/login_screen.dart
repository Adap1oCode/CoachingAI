import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:coaching_ai_new/constants/strings.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/core/widget/logo_widget.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/utils/validators.dart';
import 'package:coaching_ai_new/core/widget/back_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  String password = '';
  bool loading = false;
  String? error;
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final user = await _authService.login(
        email: email.trim(),
        password: password.trim(),
      );

      final chatIdentity = await _authService.fetchChatIdentity(
        email: email.trim(),
        userId: user.id,
      );
      debugPrint('🔍 Chat identity response: $chatIdentity');

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          RouteNames.chat,
          arguments: {
            'userId': user.id,
            'userName': user.userMetadata?['full_name'] ?? email.trim(),
            'contactId': chatIdentity['contact_id'],
            'accountId': chatIdentity['account_id'],
            'sourceId': chatIdentity['source_id'],
            'hmac': chatIdentity['hmac'],
          },
        );
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
                  SizedBox(height: constraints.maxHeight * 0.06),
                  Text(
                    AppStrings.signInTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to continue',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey[600]),
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
                              decoration: inputDecoration(AppStrings.email),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) => email = val,
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 16),
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
                              onFieldSubmitted: (_) => _login(),
                              onChanged: (val) => password = val,
                              validator: validatePassword,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, RouteNames.forgotPassword),
                              child: const Text(AppStrings.forgotPasswordCTA),
                            ),
                            const SizedBox(height: 8),
                            if (loading) const CircularProgressIndicator(),
                            if (error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: loading ? null : _login,
                              style: elevatedButtonStyle(),
                              child: const Text(AppStrings.signIn),
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
