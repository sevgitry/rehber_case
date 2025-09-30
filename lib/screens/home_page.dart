import 'package:flutter/material.dart';
import 'package:mbsb/screens/add_contact_page.dart';
import 'contacts_page.dart';

class HomePage extends StatelessWidget {
  final String userId;
  HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WhatsApp Clone")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactsPage(userId: userId),
                  ),
                );
              },
              child: const Text("Rehberi Gör"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddContactPage(userId: userId),
                  ),
                );
              },
              child: const Text("Yeni Kişi Ekle"),
            ),
          ],
        ),
      ),
    );
  }
}
