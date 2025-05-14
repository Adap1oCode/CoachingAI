import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';
import 'package:coaching_ai_new/core/utils/button_styles.dart';
import 'package:coaching_ai_new/services/auth_service.dart';

class TwoFactorSettingsSection extends StatefulWidget {
  const TwoFactorSettingsSection({super.key});

  @override
  State<TwoFactorSettingsSection> createState() => _TwoFactorSettingsSectionState();
}

class _TwoFactorSettingsSectionState extends State<TwoFactorSettingsSection> {
  final AuthService _authService = AuthService();
  final TextEditingController _codeController = TextEditingController();

  String? _qrUri;
  String? _factorId;
  String? _error;
  bool _isEnabled = false;
  bool _loading = false;
  bool _verifying = false;
  String? _challengeId;


  @override
  void initState() {
    super.initState();
    _load2FAStatus();
  }

  Future<void> _load2FAStatus() async {
    final enabled = await _authService.isTwoFactorEnabled();
    setState(() => _isEnabled = enabled);
  }

  Future<void> _startEnrollment() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final (uri, factorId) = await _authService.enrollTwoFactor();
      setState(() {
        _qrUri = uri;
        _factorId = factorId;
      });
    } catch (e) {
      setState(() => _error = 'Error enrolling 2FA: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _verifying = true;
      _error = null;
    });

    try {
      await _authService.challengeTwoFactor(_factorId!);
      await _authService.verifyTwoFactor(
        factorId: _factorId!,
        challengeId: _challengeId!,
        code: _codeController.text.trim(),
      );
      await _load2FAStatus();

      setState(() {
        _qrUri = null;
        _factorId = null;
        _codeController.clear();
      });
    } catch (e) {
      setState(() => _error = 'Invalid code: $e');
    } finally {
      setState(() => _verifying = false);
    }
  }

  Future<void> _disable2FA() async {
    setState(() => _loading = true);
    try {
      await _authService.disableTwoFactor();
      await _load2FAStatus();
    } catch (e) {
      setState(() => _error = 'Error disabling 2FA: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          'Two-Factor Authentication',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _isEnabled ? '2FA is currently enabled on your account.' : '2FA is currently disabled.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),

        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),

        if (_isEnabled && !_loading)
          ElevatedButton(
            onPressed: _disable2FA,
            style: elevatedButtonStyle(),
            child: const Text('Disable 2FA'),
          ),

        if (!_isEnabled && !_qrUriAvailable)
          ElevatedButton(
            onPressed: _startEnrollment,
            style: elevatedButtonStyle(),
            child: const Text('Enable 2FA'),
          ),

        if (_qrUriAvailable)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(child: QrImageView(data: _qrUri!, size: 200)),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                decoration: inputDecoration('Enter code from Authenticator'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _verifying ? null : _verifyCode,
                style: elevatedButtonStyle(),
                child: _verifying
                    ? const CircularProgressIndicator()
                    : const Text('Verify and Enable'),
              ),
            ],
          ),
      ],
    );
  }

  bool get _qrUriAvailable => _qrUri != null && _factorId != null;
}
