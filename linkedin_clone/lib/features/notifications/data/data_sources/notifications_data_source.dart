import 'package:linkedin_clone/features/notifications/data/models/notifications_model.dart';

abstract class NotificationDataSource {
  Future<List<NotificationsModel>> getNotifications(String companyId);
  Future<int> getUnseenNotificationsCount(String companyId);
  Future<void> markNotificationAsRead(String companyId, String notificationId);
  
  // FCM related methods
  Future<String?> getFcmToken();
  Future<void> initializeFcm();
  Stream<NotificationsModel> get notificationStream;
  
  // Method to subscribe to notifications on the server
  Future<int> subscribeToNotifications(String companyId);
}
