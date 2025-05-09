import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class N8nService {
  /// Generic POST request
  static Future<bool> _postToWebhook({
    required String url,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('n8n error: $e');
      return false;
    }
  }

  /// Send new user registration data
  static Future<Map<String, dynamic>?> registerUser({
  required String name,
  required String email,
  required String password,
}) async {
  try {
    final response = await http.post(
      Uri.parse(Env.registrationWebhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true ? data : null;
    } else {
      return null;
    }
  } catch (e) {
    print('registerUser error: $e');
    return null;
  }
}


  /// Update user info
  static Future<bool> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) {
    return _postToWebhook(
      url: Env.updateWebhookUrl,
      payload: {
        'userId': userId,
        'updates': updates,
      },
    );
  }

  /// Delete user
  static Future<bool> deleteUser(String userId) {
    return _postToWebhook(
      url: Env.deleteWebhookUrl,
      payload: {
        'userId': userId,
      },
    );
  }

  /// Sync user to Chatwoot (optional standalone call)
  static Future<bool> syncToChatwoot({
    required String name,
    required String email,
    String? identifier,
  }) {
    return _postToWebhook(
      url: Env.chatwootWebhookUrl,
      payload: {
        'name': name,
        'email': email,
        'identifier': identifier ?? email,
      },
    );
  }

  /// Fetch chat history (if webhook returns it)
  static Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(Env.chatHistoryWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print('n8n chat history error: $e');
      return [];
    }
  }
}
