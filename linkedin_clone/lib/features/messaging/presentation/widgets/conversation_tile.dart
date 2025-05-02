import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = conversation.otherParticipant;
    final message = conversation.lastMessage;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.profilePicture != null && user.profilePicture.isNotEmpty
    ? NetworkImage(user.profilePicture!)
    : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,

      ),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(message.text),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(message.sentAt),
            style: const TextStyle(fontSize: 12),
          ),
          if (conversation.unseenCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${conversation.unseenCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(dt.year, dt.month, dt.day);

      if (msgDay == today) {
        return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dt.month}/${dt.day}';
      }
    } catch (_) {
      return '';
    }
  }
}
