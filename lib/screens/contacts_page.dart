import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';
import 'chat_page.dart';
import 'add_contact_page.dart';

class ContactsPage extends ConsumerWidget {
  final String userId;
  const ContactsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsListProvider);

    // İlk build’de verileri yükle
    ref.read(contactsListProvider.notifier).fetchContacts(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rehber"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddContactPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: contactsAsync.when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(child: Text("Henüz kişi yok"));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
                leading: const CircleAvatar(child: Icon(Icons.person)),
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
