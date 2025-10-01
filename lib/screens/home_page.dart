import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../models/contact.dart';
import '../providers/messages_provider.dart';
import 'contacts_page.dart';
import 'add_contact_page.dart';
import 'chat_page.dart';

class HomePage extends ConsumerWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(recentMessagesProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts),
            tooltip: "Rehberi Gör",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ContactsPage(userId: userId)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Yeni Kişi Ekle",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddContactPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: messagesAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Sohbet geçmişi yok"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> item = list[index];
              final Message msg = item['message'];
              final Contact contact = item['contact'];
              final isMe = msg.senderId == userId;

              return ListTile(
                leading: CircleAvatar(child: Text(contact.name[0])),
                title: Text(contact.name),
                subtitle: Text(msg.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        currentUserId: userId,
                        otherUserId: contact.id,
                        otherName: contact.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Hata: $e")),
      ),
    );
  }
}
