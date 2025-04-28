import 'package:linkedin_clone/features/notifications/data/models/notifications_model.dart';
// No additional imports needed for this interface file

abstract class NotificationDataSource {
  // API Methods
  Future<List<NotificationsModel>> getNotifications();
  Future<int> getUnseenNotificationsCount();
  Future<void> markNotificationAsRead(String notificationId);

  // FCM Methods
  Future<String?> getFcmToken();
  Future<void> initializeFcm();
  Stream<NotificationsModel> get notificationStream;
}
