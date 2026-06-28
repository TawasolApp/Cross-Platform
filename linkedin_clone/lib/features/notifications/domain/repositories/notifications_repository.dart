import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notifications>>> getNotifications(String id, {int page = 1, int limit = 10});
  Future<Either<Failure, int>> getUnseenNotificationsCount(String id);
  Future<Either<Failure, void>> markNotificationAsRead(String id, String notificationId);
  Future<Either<Failure, List<Notifications>>> getUnreadNotifications(String id, {int page = 1, int limit = 10});

  // FCM related methods
  Future<Either<Failure, String?>> getFcmToken();
  Future<Either<Failure, void>> initializeFcm();
  Stream<Either<Failure, Notifications>> get notificationStream;
  Future<Either<Failure, void>> subscribeToNotifications(String id);
}