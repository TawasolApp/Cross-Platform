import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/chat_input_bar.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/message_tile.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String conversationId;
  final String userName;
  final String profileImageUrl;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.userName,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   provider.fetchMessages(conversationId);
    // });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(profileImageUrl)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 16)),
                const Text("Active now", style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    final isMe = msg.senderId == "user1"; // replace with current user logic
                    return MessageBubble(message: msg, isMe: isMe);
                  },
                ),
              ),
              ChatInputBar(
                onSend: (text) {
                 //implement send message logic here
                  print("Send message: $text");
                }
              ),
            ],
          );
        },
      ),
    );
  }
}
