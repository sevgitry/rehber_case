import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contacts_provider.dart';

class AddContactPage extends ConsumerStatefulWidget {
  final String userId;
  const AddContactPage({super.key, required this.userId});

  @override
  ConsumerState<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends ConsumerState<AddContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactsNotifier = ref.watch(contactsListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Kişi Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "İsim"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Telefon"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await contactsNotifier.addContact(
                  userId: widget.userId,
                  name: _nameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                );
                if (mounted)
                  Navigator.pop(context); // ekledikten sonra geri dön
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
