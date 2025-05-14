import 'package:uuid/uuid.dart';
import 'chat_api.dart';
import 'chat_service.dart';

class GuestChatService implements IChatService {
  final String guestUserId;
  String? contactId;
  String? accountId;
  String? sourceId;

  GuestChatService() : guestUserId = "guest_\${const Uuid().v4()}";

  @override
  Future<Map<String, dynamic>?> sendMessage({
    required String content,
    required ChatEventType eventType,
    String? conversationId,
  }) async {
    final body = {
      'event': eventType.name,
      'conversation_id': conversationId,
      'user_id': guestUserId,
      'message': content,
      if (contactId != null) 'contact_id': contactId,
      if (accountId != null) 'account_id': accountId,
      if (sourceId != null) 'source_id': sourceId,
    };

    final response = await ChatApi.sendMessage(body);

    if (response != null) {
      contactId = response['contact_id']?.toString() ?? contactId;
      accountId = response['account_id']?.toString() ?? accountId;
      sourceId = response['source_id']?.toString() ?? sourceId;
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>?> getMessages(String conversationId) {
    return ChatApi.getMessages(conversationId);
  }

  @override
  Future<List<Map<String, dynamic>>> getConversations() async {
    if (contactId == null) return [];
    return await ChatApi.getConversations(contactId!);
  }
}
