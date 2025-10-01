import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';

final messagesProvider = FutureProvider.family<List<Message>, Map<String, String>>((
  ref,
  params,
) async {
  final response = await Supabase.instance.client
      .from('messages')
      .select()
      .or(
        'sender_id.eq.${params['senderId']},receiver_id.eq.${params['receiverId']}',
      )
      .order('created_at', ascending: true);

  final data = response as List<dynamic>;
  return data.map((m) => Message.fromMap(m)).toList();
});

class SendMessageNotifier extends StateNotifier<AsyncValue<void>> {
  SendMessageNotifier() : super(const AsyncData(null));

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    state = const AsyncLoading();
    try {
      await Supabase.instance.client.from('messages').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final sendMessageProvider =
    StateNotifierProvider<SendMessageNotifier, AsyncValue<void>>(
      (ref) => SendMessageNotifier(),
    );
