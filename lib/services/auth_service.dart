import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

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

  /// Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );
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
  Future<Map<String, dynamic>> fetchChatIdentity(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Env.chatwootWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Chat identity fetch failed: ${response.body}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Chat identity error: $e');
    }
  }
}
