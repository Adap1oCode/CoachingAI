import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Login failed');
    return response;
  }

  Future<User> signUp({required String email, required String password, required String name}) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    final user = response.user;
    if (user == null) throw Exception('Sign up failed: No user returned');
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<Map<String, dynamic>> fetchChatIdentity({required String email, required String userId}) async {
    final response = await http.post(
      Uri.parse(Env.chatIdentityWebhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'user_id': userId}),
    );

    final decoded = jsonDecode(response.body);

    if (decoded is List && decoded.isNotEmpty) {
      return decoded.first as Map<String, dynamic>;
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Unexpected webhook response format');
  }

  // === Consolidated MFA methods ===

  Future<(String uri, String factorId, String challengeId)> enrollTwoFactor() async {
    final res = await _client.auth.mfa.enroll(factorType: FactorType.totp);
    final uri = res.totp?.uri;
    final factorId = res.id;
    if (factorId.isEmpty || uri == null || uri.isEmpty) throw Exception('Failed to enroll in 2FA.');

    final challenge = await _client.auth.mfa.challenge(factorId: factorId);
    if (challenge.id.isEmpty) throw Exception('Failed to challenge 2FA.');

    return (uri, factorId, challenge.id);
  }

  Future<void> verifyTwoFactor({required String factorId, required String challengeId, required String code}) async {
    final res = await _client.auth.mfa.verify(factorId: factorId, challengeId: challengeId, code: code);
    if (res.user == null) throw Exception('Invalid verification.');
  }

  Future<void> disableTwoFactor(String code) async {
    final factors = await _client.auth.mfa.listFactors();
    final totp = factors.totp.firstOrNull;
    if (totp == null) throw Exception('No TOTP factor enrolled.');

    final challenge = await _client.auth.mfa.challenge(factorId: totp.id);
    final res = await _client.auth.mfa.verify(
      factorId: totp.id,
      challengeId: challenge.id,
      code: code,
    );

    if (res.user == null) throw Exception('2FA verification failed.');

    await _client.auth.mfa.unenroll(totp.id);
  }

  Future<bool> isTwoFactorEnabled() async {
    final factors = await _client.auth.mfa.listFactors();
    return factors.totp.any((f) => f.status == FactorStatus.verified);
  }
}
