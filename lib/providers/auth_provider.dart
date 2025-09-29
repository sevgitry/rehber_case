import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

Future<User?> signUp(
  String email,
  String password,
  String username,
  String name,
  String phone,
) async {
  final response = await supabase.auth.signUp(email: email, password: password);
  final user = response.user;
  if (user != null) {
    await supabase.from('profiles').insert({
      'id': user.id,
      'username': username,
      'name': name,
      'phone_number': phone,
      'is_online': true,
      'last_seen': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  return user;
}

Future<User?> signIn(String email, String password) async {
  final response = await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
  if (response.user != null) {
    await supabase
        .from('profiles')
        .update({'is_online': true})
        .eq('id', response.user!.id);
  }
  return response.user;
}

Future<void> signOut() async {
  final user = supabase.auth.currentUser;
  if (user != null) {
    await supabase
        .from('profiles')
        .update({
          'is_online': false,
          'last_seen': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);
  }
  await supabase.auth.signOut();
}
