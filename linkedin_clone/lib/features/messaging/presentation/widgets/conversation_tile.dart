import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationTile({super.key, required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(conversation.otherParticipantProfilePic),
      ),
      title: Text(conversation.otherParticipantName),
      subtitle: Text(conversation.lastMessageText),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(conversation.lastMessageTime),
          if (conversation.unseenCount > 0)
            CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Text(
                '${conversation.unseenCount}',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
