// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final String userId;
  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  late final Stream<List<Map<String, dynamic>>> profileStream;

  @override
  void initState() {
    super.initState();
    profileStream = supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', widget.userId)
        .map((event) => event.map((e) => e as Map<String, dynamic>).toList());
  }

  @override
  void dispose() {
    // Çıkışta online durumu false yap
    supabase
        .from('profiles')
        .update({
          'is_online': false,
          'last_seen': DateTime.now().toIso8601String(),
        })
        .eq('id', widget.userId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: profileStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final profile = snapshot.data!.first;
          final isOnline = profile['is_online'] as bool;
          final lastSeen = DateTime.parse(profile['last_seen']);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile['avatar_url'] ?? ''),
                ),
                SizedBox(height: 10),
                Text("Hoşgeldin ${profile['username']}"),
                SizedBox(height: 10),
                Text(
                  "Durum: ${isOnline ? 'Çevrimiçi' : 'Son görülme: ${lastSeen.hour}:${lastSeen.minute}'}",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
