import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notifications>>> getNotifications();
  Future<Either<Failure, int>> getUnseenNotificationsCount();
  Future<Either<Failure, void>> markNotificationAsRead(String notificationId);

  // FCM related methods
  Future<Either<Failure, String?>> getFcmToken();
  Future<Either<Failure, void>> initializeFcm();
  Stream<Either<Failure, Notifications>> get notificationStream;
}
