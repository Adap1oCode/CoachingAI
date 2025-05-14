import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';

class ChatApi {
  static Future<Map<String, dynamic>?> sendMessage(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(Env.sendmessageWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 sendMessage request body: \$body');
      print('📥 sendMessage response (\${response.statusCode}): \${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('❌ Error sending message: \$e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getMessages(String conversationId) async {
    try {
      final body = {'conversation_id': conversationId};
      final response = await http.post(
        Uri.parse(Env.getmessageWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 getMessages request body: \$body');
      print('📥 getMessages response (\${response.statusCode}): \${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('❌ Error fetching messages: \$e');
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getConversations(String contactId) async {
    try {
      final body = {'contact_id': contactId};
      final response = await http.post(
        Uri.parse(Env.getconvWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 getConversations request body: \$body');
      print('📥 getConversations response (\${response.statusCode}): \${response.body}');

      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded.cast<Map<String, dynamic>>();
      if (decoded is Map<String, dynamic>) return [decoded];
    } catch (e) {
      print('❌ Error fetching conversations: \$e');
    }
    return [];
  }

  static Future<String?> getSummary({
    required String conversationId,
    required String userId,
    required String message,
    required String contactId,
    required String accountId,
    required String sourceId,
  }) async {
    final body = {
      "event": "chat_summary",
      "conversation_id": conversationId,
      "user_id": userId,
      "message": message,
      "contact_id": contactId,
      "account_id": accountId,
      "source_id": sourceId,
    };

    try {
      final response = await http.post(
        Uri.parse(Env.chatSummaryWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📤 getSummary request body: \$body');
      print('📥 getSummary response (\${response.statusCode}): \${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['summary'] ?? 'No summary returned.';
      }
    } catch (e) {
      print('❌ Error fetching summary: \$e');
    }

    return null;
  }
}
