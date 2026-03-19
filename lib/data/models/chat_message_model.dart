class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderPhone; // Идентификатор отправителя
  final String text;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderPhone,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_phone': senderPhone,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    id: json['id'],
    chatId: json['chat_id'],
    senderPhone: json['sender_phone'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}