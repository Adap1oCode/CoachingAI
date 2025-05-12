import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';


class AuthService {
  final _client = Supabase.instance.client;

  /// Sign in and return the authenticated user
  Future<User> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Login failed');
    return user;
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
      throw Exception('Sign up failed: $e');
    }
  }

  /// Send a password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  /// Fetch Chatwoot contact/account/source/hmac from n8n webhook
  Future<Map<String, dynamic>> fetchChatIdentity({
    required String email,
    required String userId,
  }) async {
    try {
      debugPrint('📤 Sending identity request to webhook for: $email, $userId');

      final response = await http.post(
        Uri.parse(Env.chatIdentityWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'user_id': userId,
        }),
      );

      debugPrint('📦 Raw webhook response: ${response.body}');

      final decoded = jsonDecode(response.body);
      debugPrint('🧪 Decoded webhook JSON type: ${decoded.runtimeType}');

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
      debugPrint('❌ Error in fetchChatIdentity: $e');
      throw Exception('Chat identity error: $e');
    }
  }
}
