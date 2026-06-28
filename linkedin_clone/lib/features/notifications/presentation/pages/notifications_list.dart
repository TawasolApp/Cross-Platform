import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';
import 'package:linkedin_clone/features/notifications/presentation/widgets/notification_item.dart';
import 'package:linkedin_clone/core/Navigation/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({Key? key}) : super(key: key);

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  String _userId = '';
  final ScrollController _notificationsScrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<NotificationsProvider>(
        context,
        listen: false,
      );

      // Get user ID
      final isCompany = await TokenService.getIsCompany();
      if (isCompany == true) {
        _userId = (await TokenService.getCompanyId()).toString();
      } else {
        _userId = (await TokenService.getUserId()).toString();
      }

      provider.initialize();

      // Mark all notifications as seen when the page is opened
      provider.markAllNotificationsAsSeen(_userId);

      // Set up scroll controller for pagination
      _notificationsScrollController.addListener(() {
        final maxScroll =
            _notificationsScrollController.position.maxScrollExtent;
        final currentScroll = _notificationsScrollController.position.pixels;
        const scrollThreshold = 200.0;

        // Detect if we need to load more
        if (maxScroll - currentScroll <= scrollThreshold &&
            !provider.isLoadingMore &&
            provider.hasMore) {
          provider.getNotifications(_userId, loadMore: true);
        }

        // Show/hide scroll-to-top button
        setState(() {
          _showScrollToTop = currentScroll > 300;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('notifications_list_page'),
      body: Consumer<NotificationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                key: Key('notifications_loading_indicator'),
              ),
            );
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                key: const Key('notifications_error_container'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.errorMessage}',
                    key: const Key('notifications_error_text'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    key: const Key('notifications_retry_button'),
                    onPressed: () async {
                      provider.resetErrors();
                      await provider.getNotifications(_userId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            key: const Key('notifications_stack'),
            children: [
              _buildNotificationsList(
                provider.notifications,
                provider,
                _notificationsScrollController,
                provider.isLoading,
                'No notifications yet',
              ),
              if (_showScrollToTop)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.small(
                    key: const Key('notifications_scroll_to_top_button'),
                    onPressed:
                        () => _notificationsScrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList(
    List<Notifications> notifications,
    NotificationsProvider provider,
    ScrollController scrollController,
    bool isLoading,
    String emptyMessage,
  ) {
    if (notifications.isEmpty && !isLoading) {
      return Center(
        child: Text(
          emptyMessage,
          key: const Key('notifications_empty_message'),
        ),
      );
    }

    return RefreshIndicator(
      key: const Key('notifications_refresh_indicator'),
      onRefresh: () async {
        await provider.getNotifications(_userId);
        await provider.getUnreadNotifications(_userId);
        await provider.getUnseenNotificationsCount(_userId);
      },
      child: ListView.builder(
        key: const Key('notifications_list_view'),
        controller: scrollController,
        itemCount: notifications.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end when loading more items
          if (index >= notifications.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(
                  key: Key('notifications_loading_more_indicator'),
                ),
              ),
            );
          }

          final notification = notifications[index];
          return _buildNotificationItem(notification, provider);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    Notifications notification,
    NotificationsProvider provider,
  ) {
    return InkWell(
      key: Key('notification_inkwell_${notification.notificationId}'),
      onTap: () async {
        if (!notification.isRead) {
          await provider.markNotificationAsRead(
            _userId,
            notification.notificationId,
          );
        }
        _handleNotificationTap(context, notification);
      },
      child: Container(
        key: Key('notification_container_${notification.notificationId}'),
        decoration: BoxDecoration(
          color:
              notification.isRead ? Colors.white : Colors.blue.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead)
              Container(
                key: Key(
                  'notification_unread_indicator_${notification.notificationId}',
                ),
                width: 4,
                height: 80,
                color: Colors.blue,
              ),
            Expanded(
              child: NotificationItem(
                notification: notification,
                onTap: (notification) {
                  _handleNotificationTap(context, notification);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    Notifications notification,
  ) {
    // Navigate based on notification type
    switch (notification.type) {
      case 'React':
        // Navigate to post details
        context.push(
          RouteNames.postDetails,
          extra: notification.rootItemId,
        );
        break;
      case 'Comment':
        // Navigate to post details with comment focus
        context.push(
          RouteNames.postDetails,
          extra: notification.rootItemId,
        );
        break;
      case 'UserConnection':
        // Navigate to profile
        context.push(RouteNames.profile, extra: notification.referenceId);
        break;
      case 'Message':
        // Navigate to messages - implement this when you have the messages route
        // context.push(RouteNames.messages, extra: notification.referenceId);
        break;
      case 'JobOffer':
        // Navigate to job details - implement this when you have the job details route
        // context.push(RouteNames.jobDetails, extra: notification.referenceId);
        context.push(RouteNames.companyPage, extra: notification.referenceId);
        
        break;
      default:
        // Default action
        break;
    }
  }
}
