import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/core/services/messaging_socket_service.dart';
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
  XFile? _selectedImage;

  final ImagePicker _picker = ImagePicker();

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

  MessagingSocketService _socketService = MessagingSocketService();

  Future<void> _handleImagePick() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _handleSend(String text) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendTextMessage(
      widget.receiverId,
      text,
      _selectedImage ?? XFile(''), // Pass image or empty
    );

    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('backButton'),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              key: const Key('profileImage'),
              backgroundImage: widget.profileImageUrl.isNotEmpty
                  ? NetworkImage(widget.profileImageUrl)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  key: const Key('userNameText'),
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  "Active now",
                  key: Key('activeStatusText'),
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              key: Key('loadingIndicator'),
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  key: const Key('messageListView'),
                  reverse: true,
                  controller: _scrollController,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    final isMe = msg.senderId == currentUserId;
                    return MessageBubble(
                      key: Key('messageBubble_${msg.id}'),
                      message: msg,
                      isMe: isMe,
                    );
                  },
                ),
              ),
              if (provider.isTyping)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Typing...",
                      key: const Key('typingIndicator'),
                      style: TextStyle(
                          color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ChatInputBar(
                key: const Key('chatInputBar'),
                onTyped: (text) {
                  context.read<ChatProvider>().sendTyping(widget.receiverId);
                },
                onSend: _handleSend,
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImage!.path),
                          height: 100,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImage = null),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: _handleImagePick,
              ),
            ],
          );
        },
      ),
    );
  }
}
