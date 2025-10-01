class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      senderId: map['sender_id'].toString(),
      receiverId: map['receiver_id'].toString(),
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
