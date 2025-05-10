import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ChatService {
  static const String sendMessageUrl = '${Env.n8nBaseUrl}/send_message';
  static const String getMessagesUrl = '${Env.n8nBaseUrl}/get_messages';

  static Future<Map<String, dynamic>?> sendMessage(String? conversationId, String content) async {
    try {
      final response = await http.post(
        Uri.parse(sendMessageUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversation_id': conversationId,
          'message': content,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to send message: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final response = await http.get(
      Uri.parse('$getMessagesUrl?conversation_id=$conversationId'),
    );

    if (response.statusCode == 200) {
      List raw = jsonDecode(response.body);
      return raw.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
