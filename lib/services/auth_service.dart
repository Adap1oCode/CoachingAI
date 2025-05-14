// =========================
// auth_service.dart
// =========================

import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final _client = Supabase.instance.client;

  /// Sign in and return the authenticated user + session
  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Login failed');
    return response;
  }

  /// Sign up a new user and return the created user
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );

      final user = response.user;
      if (user == null) throw Exception('Sign up failed: No user returned');

      return user;
    } catch (e) {
      throw Exception('Sign up failed: \$e');
    }
  }

  /// Send a password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Reset password failed: \$e');
    }
  }

  /// Fetch Chatwoot contact/account/source/hmac from n8n webhook
  Future<Map<String, dynamic>> fetchChatIdentity({
    required String email,
    required String userId,
  }) async {
    try {
      debugPrint('📤 Sending identity request to webhook for: \$email, \$userId');

      final response = await http.post(
        Uri.parse(Env.chatIdentityWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'user_id': userId,
        }),
      );

      debugPrint('📦 Raw webhook response: \${response.body}');

      final decoded = jsonDecode(response.body);
      debugPrint('🧪 Decoded webhook JSON type: \${decoded.runtimeType}');

      if (decoded is List && decoded.isNotEmpty) {
        debugPrint('📥 Returning first item from webhook response list');
        return decoded.first as Map<String, dynamic>;
      }

      if (decoded is Map<String, dynamic>) {
        debugPrint('📥 Returning map directly from webhook response');
        return decoded;
      }

      throw Exception('Unexpected webhook response format');
    } catch (e) {
      debugPrint('❌ Error in fetchChatIdentity: \$e');
      throw Exception('Chat identity error: \$e');
    }
  }

  // ==================================================
  // =============== TWO-FACTOR METHODS ===============
  // ==================================================

  /// Enroll user in TOTP 2FA (returns URI for QR code + factorId)
  Future<(String uri, String factorId)> enrollTwoFactor() async {
    final res = await _client.auth.mfa.enroll(factorType: FactorType.totp);
    final uri = res.totp.uri;
    final factorId = res.id;

    if (factorId.isEmpty) {
      throw Exception('Failed to enroll in 2FA.');
    }

    return (uri, factorId);
  }

  /// Challenge a factor (before verify)
  Future<String> challengeTwoFactor(String factorId) async {
    final res = await _client.auth.mfa.challenge(factorId: factorId);
    if (res.id.isEmpty) {
      throw Exception('Failed to initiate 2FA challenge.');
    }
    return res.id;
  }

  /// Verify the TOTP code to complete login or enrollment
  Future<void> verifyTwoFactor({
    required String factorId,
    required String challengeId,
    required String code,
  }) async {
    await _client.auth.mfa.verify(
      factorId: factorId,
      challengeId: challengeId,
      code: code,
    );
  }

  /// Disable TOTP (removes the active factor)
  Future<void> disableTwoFactor() async {
    final factors = await _client.auth.mfa.listFactors();
    final verified = factors.totp.where((f) => f.status == FactorStatus.verified).toList();
    if (verified.isEmpty) throw Exception('No 2FA factor to disable');

    await _client.auth.mfa.unenroll(verified.first.id);
  }

  /// Check if user has verified TOTP 2FA enabled
  Future<bool> isTwoFactorEnabled() async {
    final factors = await _client.auth.mfa.listFactors();
    return factors.totp.any((f) => f.status == FactorStatus.verified);
  }
}