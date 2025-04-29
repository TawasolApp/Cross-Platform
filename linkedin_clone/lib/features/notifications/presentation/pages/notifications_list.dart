import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';
import 'package:linkedin_clone/features/notifications/presentation/widgets/notification_item.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({Key? key}) : super(key: key);

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationsProvider>(
        context,
        listen: false,
      );
      if(TokenService.getIsCompany() == true)
      {
        final companyId = TokenService.getCompanyId().toString();
        provider.initialize(companyId);
      }
      else
      {
        final userId = TokenService.getUserId().toString();
        provider.initialize(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Consumer<NotificationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      provider.resetErrors();
                      final isCompany = await TokenService.getIsCompany();
                      if(isCompany == true)
                      {
                        final companyId = (await TokenService.getCompanyId()).toString();
                        provider.initialize(companyId);
                      }
                      else
                      {
                        final userId = (await TokenService.getUserId()).toString();
                        provider.initialize(userId);
                      }

                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final notifications = provider.notifications;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              if(TokenService.getIsCompany() == true)
              {
                final companyId = (await TokenService.getCompanyId()).toString();
                provider.getNotifications(companyId);
              }
              else
              {
                final userId = (await TokenService.getUserId()).toString();
                provider.getNotifications(userId);
              }
            },
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationItem(
                  notification: notification,
                  onTap: (notification) {
                    _handleNotificationTap(context, notification);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    Notifications notification,
  ) {
    // Navigate based on notification type
    switch (notification.type) {
      case 'Post':
        // Navigate to post details
        // Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailsPage(postId: notification.referenceId)));
        break;
      case 'Connection':
        // Navigate to profile
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(userId: notification.referenceId)));
        break;
      case 'Message':
        // Navigate to messages
        // Navigator.push(context, MaterialPageRoute(builder: (_) => MessagesPage(chatId: notification.referenceId)));
        break;
      default:
        // Default action
        break;
    }
  }
}
