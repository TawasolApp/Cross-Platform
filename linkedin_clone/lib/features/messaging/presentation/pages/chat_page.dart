import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/chat_input_bar.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/message_tile.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/services/token_service.dart'; // for getting userId

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String receiverId; // Add this line
  final String userName;
  final String profileImageUrl;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.receiverId, // Add this line
    required this.userName,
    required this.profileImageUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String currentUserId = '';
  late ChatProvider _chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final userId = await TokenService.getUserId();
    setState(() => currentUserId = userId ?? '');

    _chatProvider.setConversationId(widget.conversationId);
    _chatProvider.setUserName(widget.userName);
    _chatProvider.setUserImage(widget.profileImageUrl);
    _chatProvider.setCurrentUserId(currentUserId);
    _chatProvider.fetchMessages(widget.conversationId);
    print('Fetching messages for conversationId: ${widget.conversationId}');
    print('Current userId: $currentUserId');
    _chatProvider.initSocket(currentUserId, widget.conversationId);
  }

  @override
  void dispose() {
    _chatProvider.disposeSocket(); // ✅ SAFE
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
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
                  onSend: (text) async{
                    final userId = await TokenService.getUserId() ?? '';
                    print(userId);
                    //print('Sending message to ${widget.receiverId}: $text');
                    _chatProvider.sendTextMessage(
                      widget.receiverId, // Replace with actual receiverId
                      text,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
