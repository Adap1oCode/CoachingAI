import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/auth_service.dart';
import '../utils/form_decorators.dart';
import '../utils/button_styles.dart';

class TwoFactorSettingsSection extends StatefulWidget {
  const TwoFactorSettingsSection({super.key});

  @override
  State<TwoFactorSettingsSection> createState() => _TwoFactorSettingsSectionState();
}

class _TwoFactorSettingsSectionState extends State<TwoFactorSettingsSection> {
  final _authService = AuthService();
  final _codeController = TextEditingController();

  String? _qrUri;
  String? _factorId;
  String? _challengeId;
  String? _error;
  bool _isEnabled = false;
  bool _loading = false;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _check2FAStatus();
  }

  Future<void> _check2FAStatus() async {
    try {
      final enabled = await _authService.isTwoFactorEnabled();
      setState(() => _isEnabled = enabled);
    } catch (e) {
      setState(() => _error = 'Error checking 2FA status: $e');
    }
  }

  Future<void> _startEnrollment() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final (uri, factorId, challengeId) = await _authService.enrollTwoFactor();
      setState(() {
        _qrUri = uri;
        _factorId = factorId;
        _challengeId = challengeId;
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
      await _authService.verifyTwoFactor(
        factorId: _factorId!,
        challengeId: _challengeId!,
        code: _codeController.text.trim(),
      );
      await _check2FAStatus();
      _resetState();
    } catch (e) {
      setState(() => _error = 'Invalid code: $e');
    } finally {
      setState(() => _verifying = false);
    }
  }

  Future<void> _disable2FA() async {
    final code = await _promptFor2FACode();
    if (code == null) return;

    try {
      await _authService.disableTwoFactor(code);
      await _check2FAStatus();
      _showSnack('✅ 2FA disabled');
    } catch (e) {
      _showSnack('❌ Error disabling 2FA: $e');
    }
  }

  Future<String?> _promptFor2FACode() async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter 2FA Code'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '2FA code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _resetState() {
    setState(() {
      _qrUri = null;
      _factorId = null;
      _challengeId = null;
      _codeController.clear();
    });
  }

  void _showSnack(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  bool get _qrUriAvailable => _qrUri != null && _factorId != null && _challengeId != null;

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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),

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
              Center(
                child: QrImageView(
                  data: _qrUri!,
                  size: 200.0,
                ),
              ),
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
}
