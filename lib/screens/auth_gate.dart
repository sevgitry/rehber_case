import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/screens/login_page.dart';
import '/screens/home_page.dart';

// Riverpod stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Oturum varsa HomePage'e yönlendir
          return HomePage(userId: user.id);
        } else {
          // Oturum yoksa LoginPage'e yönlendir
          return LoginPage();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Hata oluştu: $err'))),
    );
  }
}
