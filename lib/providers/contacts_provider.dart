import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contact.dart';

class ContactsListNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  ContactsListNotifier() : super(const AsyncLoading());

  /// Kullanıcının rehberini getir
  Future<void> fetchContacts(String userId) async {
    try {
      state = const AsyncLoading();
      final response = await Supabase.instance.client
          .from('contacts')
          .select()
          .eq('user_id', userId);

      final data = response as List<dynamic>;
      state = AsyncData(data.map((c) => Contact.fromMap(c)).toList());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Yeni kişi ekle ve listeyi güncelle
  Future<void> addContact({
    required String userId,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      state = const AsyncLoading();
      await Supabase.instance.client.from('contacts').insert({
        'user_id': userId,
        'name': name,
        'phone_number': phoneNumber,
        'created_at': DateTime.now().toIso8601String(),
      });
      await fetchContacts(userId); // ekledikten sonra listeyi yenile
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final contactsListProvider =
    StateNotifierProvider<ContactsListNotifier, AsyncValue<List<Contact>>>(
      (ref) => ContactsListNotifier(),
    );
