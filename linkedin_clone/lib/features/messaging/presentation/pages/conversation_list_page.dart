import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/presentation/pages/chat_page.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:linkedin_clone/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  final Set<String> selectedConversationIds = {};

  void toggleSelection(String conversationId) {
    setState(() {
      if (selectedConversationIds.contains(conversationId)) {
        selectedConversationIds.remove(conversationId);
      } else {
        selectedConversationIds.add(conversationId);
      }
    });
  }

  void clearSelection() {
    setState(() {
      selectedConversationIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversationProvider = Provider.of<ConversationListProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final isSelecting = selectedConversationIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: isSelecting
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: clearSelection,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(isSelecting
            ? '${selectedConversationIds.length} selected'
            : 'Messages'),
        actions: isSelecting
            ? [
                IconButton(
                  tooltip: 'Mark as Read',
                  icon: const Icon(Icons.mark_email_read_outlined),
                  onPressed: () {
                    for (final id in selectedConversationIds) {
                      conversationProvider.markConversationAsRead(id);
                    }
                    clearSelection();
                  },
                ),
                IconButton(
                  tooltip: 'Mark as Unread',
                  icon: const Icon(Icons.mark_email_unread_outlined),
                  onPressed: () {
                    for (final id in selectedConversationIds) {
                      conversationProvider.markConversationAsUnread(id);
                    }
                    clearSelection();
                  },
                ),
              ]
            : null,
      ),
      body: conversationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversationProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversationProvider.conversations[index];
                final isSelected = selectedConversationIds.contains(conversation.id);
                final isUnread = conversation.unseenCount > 0;

                return ConversationTile(
                  conversation: conversation,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelecting) {
                      toggleSelection(conversation.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversationId: conversation.id,
                            receiverId: conversation.otherParticipant.id,
                            userName:
                                '${conversation.otherParticipant.firstName} ${conversation.otherParticipant.lastName}',
                            profileImageUrl:
                                conversation.otherParticipant.profilePicture,
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    toggleSelection(conversation.id);
                  },
                );
              },
            ),
    );
  }
}
