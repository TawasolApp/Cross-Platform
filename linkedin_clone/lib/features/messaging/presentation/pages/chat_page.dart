import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/chat_input_bar.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/message_tile.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/services/token_service.dart';


class ChatPage extends StatefulWidget {
  final String conversationId;
  final String receiverId;
  final String userName;
  final String profileImageUrl;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.userName,
    required this.profileImageUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String currentUserId = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final userId = await TokenService.getUserId();
    currentUserId = userId ?? '';

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setConversationId(widget.conversationId);
    chatProvider.setUserName(widget.userName);
    chatProvider.setUserImage(widget.profileImageUrl);
    chatProvider.setCurrentUserId(currentUserId);
    await chatProvider.fetchMessages(widget.conversationId);
    chatProvider.initSocket(currentUserId, widget.conversationId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.profileImageUrl.isNotEmpty
                  ? NetworkImage(widget.profileImageUrl)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
            ),
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
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    final isMe = msg.senderId == currentUserId;
                    return MessageBubble(message: msg, isMe: isMe);
                  },
                ),
              ),
             if (provider.isTyping)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Typing...",
                      style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ChatInputBar(
                onTyped: (text) {
                  context.read<ChatProvider>().sendTyping(widget.receiverId);
                },
                onSend: (text) async {
                  final userId = await TokenService.getUserId() ?? '';
                  Provider.of<ChatProvider>(context, listen: false).sendTextMessage(
                    widget.receiverId,
                    text,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
