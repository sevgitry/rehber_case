import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contacts_provider.dart';
import 'chat_page.dart';

class ContactsPage extends ConsumerWidget {
  final String userId;
  const ContactsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text("Rehber")),
      body: contactsAsync.when(
        data: (contacts) {
          // Rehber boşsa uyarı göster
          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                "Rehberiniz boş. Lütfen önce yeni kişi ekleyin.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          // Rehber doluysa listele
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (_, index) {
              final c = contacts[index];
              return ListTile(
                title: Text(c['name']),
                subtitle: Text(c['phone_number']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatPage(senderId: userId, receiverId: c['id']),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Hata: $err")),
      ),
    );
  }
}
