import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/conversation_tile.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConversationListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = provider.conversations[index];
                return ConversationTile(
                  conversation: conversation,
                  onTap: () {
                    print('Open chat for conversationId: ${conversation.id}');
                    // Navigate to chat page
                  },
                );
              },
            ),
    );
  }
}
