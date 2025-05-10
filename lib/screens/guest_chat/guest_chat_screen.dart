import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart'; // ✅ CORRECT


class ChatService {
  static const String sendMessageUrl = Env.sendmessageWebhookUrl;
  static const String getMessagesUrl = Env.getmessageWebhookUrl;


  /// Sends a message to the backend via n8n.
  /// If [conversationId] is null, assumes it's the first message.
  static Future<Map<String, dynamic>?> sendMessage(
      String? conversationId, String content) async {
    try {
      final isNewConversation = conversationId == null;

      final response = await http.post(
        Uri.parse(sendMessageUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversation_id': conversationId,
          'message': content,
          'event': isNewConversation ? 'conversation_created' : 'message_created',
        }),
      );

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

  /// Fetches all messages for a given conversation.
  static Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse('$getMessagesUrl?conversation_id=$conversationId'),
      );

      if (response.statusCode == 200) {
        List raw = jsonDecode(response.body);
        return raw.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('❌ Error fetching messages: $e');
      return [];
    }
  }
}
