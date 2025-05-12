/// Enum for different types of chat events
enum ChatEventType {
  firstConversation,
  newConversation,
  newMessage,
}

extension ChatEventTypeExt on ChatEventType {
  String get name {
    switch (this) {
      case ChatEventType.firstConversation:
        return 'first_conversation';
      case ChatEventType.newConversation:
        return 'new_conversation';
      case ChatEventType.newMessage:
        return 'new_message';
    }
  }
}
