import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final Function(Notifications) onTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContent(context),
                const SizedBox(height: 4),
                _buildTimeStamp(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[300],
      backgroundImage: notification.profilePicture.isNotEmpty
          ? NetworkImage(notification.profilePicture)
          : null,
      child: notification.profilePicture.isEmpty
          ? Icon(
              _getNotificationIcon(),
              color: Colors.grey[700],
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextStyle nameStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: notification.userName,
            style: nameStyle,
          ),
          TextSpan(
            text: ' ${notification.content}',
          ),
        ],
      ),
    );
  }

  Widget _buildTimeStamp() {
    return Text(
      timeago.format(notification.timestamp),
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case 'Post':
        return Icons.article_outlined;
      case 'Connection':
        return Icons.person_add_alt_1_outlined;
      case 'Message':
        return Icons.message_outlined;
      case 'Job':
        return Icons.work_outline;
      case 'Comment':
        return Icons.comment_outlined;
      case 'Like':
        return Icons.thumb_up_alt_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}