import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';
import 'package:coaching_ai_new/core/widget/back_button_widget.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _error;
  bool _loading = false;
  String? _factorId;
  String? _challengeId;
  String? _userId;
  String? _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _userId = args['userId'];
      _email = args['email'];
    }

    _initChallenge();
  }

  Future<void> _initChallenge() async {
    setState(() => _loading = true);
    try {
      final factors = await Supabase.instance.client.auth.mfa.listFactors();
      final verified = factors.totp.where((f) => f.status == FactorStatus.verified).toList();

      if (verified.isEmpty) {
        throw Exception('No verified TOTP factor found for this user.');
      }

      final factor = verified.first;
      _factorId = factor.id;

      final challenge = await Supabase.instance.client.auth.mfa.challenge(factorId: factor.id);
      _challengeId = challenge.id;
    } catch (e) {
      setState(() => _error = 'Failed to start 2FA challenge: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final code = _codeController.text.trim();

      if (_factorId == null || _challengeId == null) {
        throw Exception('Missing 2FA factor or challenge.');
      }

      await Supabase.instance.client.auth.mfa.verify(
        factorId: _factorId!,
        challengeId: _challengeId!,
        code: code,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        RouteNames.chat,
        arguments: {
          'userId': _userId,
          'userName': _email,
          'contactId': null,
          'accountId': null,
          'sourceId': null,
          'hmac': null,
        },
      );
    } catch (e) {
      setState(() => _error = 'Invalid code: $e');
    } finally {
      setState(() => _loading = false);
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
        title: const Text('Two-Factor Authentication'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                decoration: inputDecoration('Enter 2FA Code'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verifyCode(),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              _loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyCode,
                        style: elevatedButtonStyle(),
                        child: const Text('Verify'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
