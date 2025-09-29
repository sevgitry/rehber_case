import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbsb/screens/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fbwpcotqtpznscxbqmmg.supabase.co',
    anonKey: 'sb_publishable_KF3K0oKxrLT1QZlcoU2pAw_4GmnbFZI',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WelcomePage(),
    );
  }
}
