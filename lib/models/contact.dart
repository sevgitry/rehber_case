class Contact {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final DateTime createdAt;

  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
