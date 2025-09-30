import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messagesProvider =
    StreamProvider.family<List<Map<String, dynamic>>, Map<String, String>>((
      ref,
      ids,
    ) {
      final senderId = ids['senderId']!;
      final receiverId = ids['receiverId']!;

      return Supabase.instance.client
          .from('messages')
          .stream(primaryKey: ['id'])
          .map((event) {
            // Flutter tarafında filtreleme: sadece bu iki kullanıcı arasındaki mesajlar
            return event
                .where(
                  (msg) =>
                      (msg['sender_id'] == senderId &&
                          msg['receiver_id'] == receiverId) ||
                      (msg['sender_id'] == receiverId &&
                          msg['receiver_id'] == senderId),
                )
                .toList();
          });
    });

class ChatPage extends ConsumerStatefulWidget {
  final String senderId;
  final String receiverId;
  ChatPage({required this.senderId, required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    await Supabase.instance.client.from('messages').insert({
      'sender_id': widget.senderId,
      'receiver_id': widget.receiverId,
      'content': _controller.text,
      'created_at': DateTime.now().toIso8601String(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(
      messagesProvider({
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
      }),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final m = messages[index];
                  final isMe = m['sender_id'] == widget.senderId;
                  return ListTile(
                    title: Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: isMe ? Colors.green[200] : Colors.grey[300],
                        child: Text(m['content']),
                      ),
                    ),
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
