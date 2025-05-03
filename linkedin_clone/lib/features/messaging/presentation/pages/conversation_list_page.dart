import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/pages/chat_page.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/conversation_tile.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationProvider = Provider.of<ConversationListProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: conversationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversationProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversationProvider.conversations[index];
                print("Conversations loaded: ${conversation.id}");
                return ConversationTile(
                  conversation: conversation,
                  onTap: () {
                    print('Open chat for conversationId: ${conversation.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          conversationId: conversation.id,
                          userName: conversation.otherParticipant.firstName + ' ' + conversation.otherParticipant.lastName,
                          profileImageUrl: conversation.otherParticipant.profilePicture,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
