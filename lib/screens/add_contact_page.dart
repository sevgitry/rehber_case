import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'contacts_page.dart';

class AddContactPage extends StatefulWidget {
  final String userId;
  const AddContactPage({super.key, required this.userId});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _addContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen isim ve telefon girin")),
      );
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kullanıcı bulunamadı")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await supabase.from('contacts').insert({
        'user_id': user.id,
        'name': name,
        'phone_number': phone,
        'created_at': DateTime.now().toIso8601String(),
      });

      // insert tamamlandıktan sonra rehber sayfasına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ContactsPage(userId: user.id)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kişi Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'İsim'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addContact,
                    child: const Text('Ekle'),
                  ),
          ],
        ),
      ),
    );
  }
}
