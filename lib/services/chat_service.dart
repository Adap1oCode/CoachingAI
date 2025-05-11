import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ChatService {
  /// Send a message to the backend via n8n webhook
  /// Supports: first_conversation, new_conversation, new_message
  static Future<Map<String, dynamic>?> sendMessage(
    String? conversationId,
    String content,
    String userId,
    String eventType, {
    String? contactId,
    String? accountId,
    String? sourceId, // ✅ NEW PARAM
  }) async {
    try {
      final body = {
        'event': eventType,
        'conversation_id': conversationId,
        'user_id': userId,
        'message': content,
      };

      if (contactId != null) body['contact_id'] = contactId;
      if (accountId != null) body['account_id'] = accountId;
      if (sourceId != null) body['source_id'] = sourceId; // ✅ INCLUDE IN PAYLOAD

      final response = await http.post(
        Uri.parse(Env.sendmessageWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 sendMessage request body: $body');
      print('📥 sendMessage response (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Failed to send message: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      return null;
    }
  }

  /// Fetch messages for a given conversation
  static Future<Map<String, dynamic>?> getMessages(String conversationId) async {
    try {
      final body = {'conversation_id': conversationId};
      final response = await http.post(
        Uri.parse(Env.getmessageWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 getMessages request body: $body');
      print('📥 getMessages response (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Failed to load messages: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching messages: $e');
      return null;
    }
  }

  /// Fetch all conversations for a given contact_id
  static Future<List<Map<String, dynamic>>> getConversations(String contactId) async {
    try {
      final body = {'contact_id': contactId};
      final response = await http.post(
        Uri.parse(Env.getconvWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 getConversations request body: $body');
      print('📥 getConversations response (${response.statusCode}): ${response.body}');

      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      } else if (decoded is Map<String, dynamic>) {
        return [decoded];
      } else {
        print('❌ Unexpected conversations response format: $decoded');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      return [];
    }
  }
}
