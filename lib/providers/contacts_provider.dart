import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final contactsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
      return Supabase.instance.client
          .from('contacts')
          .stream(primaryKey: ['id'])
          .map((event) {
            return event.where((c) => c['user_id'] == userId).toList();
          });
    });
