class Message {
  final int messageId;
  final String message;
  final String senderId;
  final String receiverId;
  final bool read;
  final DateTime sentAt;

  Message({
    required this.messageId,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.read,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      message: json['message'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      read: json['read'],
      sentAt: DateTime.parse(json['sent_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'message': message,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'read': read,
      'sent_at': sentAt.toIso8601String(),
    };
  }
}
