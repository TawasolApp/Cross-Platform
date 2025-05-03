import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/chat_input_bar.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/message_tile.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/services/token_service.dart'; // for getting userId

class ChatPage extends StatefulWidget {
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
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String currentUserId = '';

  @override
  void initState() {
    _initChat();
    super.initState();
    
  }

  Future<void> _initChat() async {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    final userId = await TokenService.getUserId();
    setState(() => currentUserId = userId ?? '');

    provider.setConversationId(widget.conversationId);
    provider.setUserName(widget.userName);
    provider.setUserImage(widget.profileImageUrl);
    provider.setCurrentUserId(currentUserId);

    provider.fetchMessages(widget.conversationId);
    provider.initSocket(currentUserId, widget.conversationId);
  }

  @override
  void dispose() {
    Provider.of<ChatProvider>(context, listen: false).disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profileImageUrl)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName, style: const TextStyle(fontSize: 16)),
                const Text("Active now", style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = provider.messages[index];
                      final isMe = msg.senderId == currentUserId;
                      return MessageBubble(message: msg, isMe: isMe);
                    },
                  ),
                ),
                ChatInputBar(
                  onSend: (text) {
                    provider.sendTextMessage(
                      "6811533cb3b2dd6683917cc0",
                      text,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
