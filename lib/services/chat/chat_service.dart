// =========================
// chat_service.dart
// =========================

enum ChatEventType {
  firstConversation,
  newConversation,
  newMessage,
  initialAccountChat, // ✅ Renamed from initialUserMessage
}

extension ChatEventTypeExtension on ChatEventType {
  String get name {
    switch (this) {
      case ChatEventType.firstConversation:
        return 'first_conversation';
      case ChatEventType.newConversation:
        return 'new_conversation';
      case ChatEventType.newMessage:
        return 'new_message';
      case ChatEventType.initialAccountChat:
        return 'initial_account_chat'; // ✅ Updated string
    }
  }
}