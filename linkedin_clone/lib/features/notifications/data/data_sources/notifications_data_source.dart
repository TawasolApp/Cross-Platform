import 'package:linkedin_clone/features/notifications/data/models/notifications_model.dart';
// No additional imports needed for this interface file

abstract class NotificationDataSource {
  // API Methods
  Future<List<NotificationsModel>> getNotifications(String id, {int page = 1, int limit = 10});
  Future<int> getUnseenNotificationsCount(String id);
  Future<void> markNotificationAsRead(String id, String notificationId);
  Future<List<NotificationsModel>> getUnreadNotifications(String id, {int page = 1, int limit = 10});

  // FCM Methods
  Future<String?> getFcmToken();
  Future<void> initializeFcm();
  Stream<NotificationsModel> get notificationStream;
  Future<void> subscribeToNotifications(String id);
}
