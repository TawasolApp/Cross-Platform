import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notifications>>> getNotifications(String companyId);
  Future<Either<Failure, int>> getUnseenNotificationsCount(String companyId);
  Future<Either<Failure, void>> markNotificationAsRead(String companyId, String notificationId);

  // FCM related methods
  Future<Either<Failure, String?>> getFcmToken();
  Future<Either<Failure, void>> initializeFcm();
  Stream<Either<Failure, Notifications>> get notificationStream;
  Future<Either<Failure, void>> subscribeToNotifications(String companyId);
}
