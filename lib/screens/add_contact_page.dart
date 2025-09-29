import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Kişi Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'İsim'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _phoneController.text.isEmpty)
                  return;
                await supabase.from('contacts').insert({
                  'user_id': user!.id,
                  'name': _nameController.text,
                  'phone_number': _phoneController.text,
                  'created_at': DateTime.now().toIso8601String(),
                });
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
