import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coaching_ai_new/constants/strings.dart';
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

  Future<void> _verifyCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final code = _codeController.text.trim();
    try {
      final response = await http.post(
        Uri.parse('https://n8n.flowmaticai.cloud/verify_2fa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, RouteNames.chat);
      } else {
        setState(() {
          _error = 'Invalid code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error verifying code: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
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
