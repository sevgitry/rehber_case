import 'package:flutter/material.dart';
import 'package:mbsb/providers/auth_provider.dart';
// <- signUp fonksiyonunu kullanabilmek için import

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'İsim'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);

                      final user = await signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _usernameController.text.trim(),
                        _nameController.text.trim(),
                        _phoneController.text.trim(),
                      );

                      setState(() => loading = false);

                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kayıt başarılı! Lütfen giriş yapın.',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kayıt sırasında bir hata oluştu.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Kayıt Ol'),
                  ),
          ],
        ),
      ),
    );
  }
}
