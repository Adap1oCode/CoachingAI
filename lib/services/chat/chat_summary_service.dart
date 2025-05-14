import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';

class ChatSummaryService {
  static Future<String> generateSummary({
    required String conversationId,
    required String userId,
    required String message,
    required String contactId,
    required String accountId,
    required String sourceId,
  }) async {
    final response = await http.post(
      Uri.parse(Env.chatSummaryWebhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "event": "chat_summary",
        "conversation_id": conversationId,
        "user_id": userId,
        "message": message,
        "contact_id": contactId,
        "account_id": accountId,
        "source_id": sourceId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Summary request failed: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['summary'] ?? 'No summary provided.';
  }
}
