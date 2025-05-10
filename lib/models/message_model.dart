// lib/models/message_model.dart
class MessageModel {
  final String id;
  final String content;
  final String sender;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
      content: json['content'] ?? '',
      sender: json['sender'] ?? 'user',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
