
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({Key? key}) : super(key: key);

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
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        setState(() {
          _error = 'Invalid code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error verifying code: \$e';
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
      appBar: AppBar(title: const Text('Two-Factor Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter 2FA Code'),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyCode,
                    child: const Text('Verify'),
                  ),
          ],
        ),
      ),
    );
  }
}
