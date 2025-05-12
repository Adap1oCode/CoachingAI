enum ChatEventType {
  firstConversation,
  newConversation,
  newMessage,
  initialUserMessage, // ✅ <-- Add this
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
      case ChatEventType.initialUserMessage:
        return 'initial_user_message';
    }
  }
}
