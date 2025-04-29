import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final Function(Notifications)? onTap;

  const NotificationItem({Key? key, required this.notification, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final provider = Provider.of<NotificationsProvider>(
          context,
          listen: false,
        );
        if(TokenService.getIsCompany() == true)
        {
          final companyId = TokenService.getCompanyId().toString();
           provider.markNotificationAsRead(companyId, notification.notificationId);
        }
        else
        {
          final userId = TokenService.getUserId().toString();
           provider.markNotificationAsRead(userId, notification.notificationId);
        }
        
        if (onTap != null) {
          onTap!(notification);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: notification.isRead ? null : Colors.blue.withOpacity(0.1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage:
                  notification.profilePicture.isNotEmpty
                      ? NetworkImage(notification.profilePicture)
                      : null,
              child:
                  notification.profilePicture.isEmpty
                      ? Text(
                        notification.userName.isNotEmpty
                            ? notification.userName[0].toUpperCase()
                            : '?',
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: notification.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${notification.content}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(notification.timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
