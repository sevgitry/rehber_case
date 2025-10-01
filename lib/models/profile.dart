class Profile {
  final String id;
  final String username;
  final String name;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime lastSeen;
  final String phoneNumber;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.username,
    required this.name,
    this.avatarUrl,
    required this.isOnline,
    required this.lastSeen,
    required this.phoneNumber,
    required this.createdAt,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'].toString(),
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatar_url'],
      isOnline: map['is_online'] ?? false,
      lastSeen: DateTime.parse(map['last_seen']),
      phoneNumber: map['phone_number'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
