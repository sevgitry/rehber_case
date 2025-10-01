// pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isRegister = false;

  final supabase = Supabase.instance.client;

  Future<void> _auth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isRegister) {
      final username = _usernameController.text.trim();
      final phone = _phoneController.text.trim();

      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'phone_number': phone},
      );

      if (res.user != null) {
        await supabase.from('profiles').insert({
          'id': res.user!.id,
          'username': username,
          'phone_number': phone,
          'name': username,
          'is_online': true,
          'last_seen': DateTime.now().toIso8601String(),
        });
      }
    } else {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        await supabase
            .from('profiles')
            .update({
              'is_online': true,
              'last_seen': DateTime.now().toIso8601String(),
            })
            .eq('id', res.user!.id);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(userId: res.user!.id)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegister ? "Kayıt Ol" : "Giriş Yap")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRegister)
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Kullanıcı Adı"),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Şifre"),
              obscureText: true,
            ),
            if (_isRegister)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefon Numarası"),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _auth,
              child: Text(_isRegister ? "Kayıt Ol" : "Giriş Yap"),
            ),
            TextButton(
              onPressed: () {
                setState(() => _isRegister = !_isRegister);
              },
              child: Text(_isRegister ? "Zaten hesabım var" : "Hesap oluştur"),
            ),
          ],
        ),
      ),
    );
  }
}
