import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/errors/exceptions.dart';
import 'package:linkedin_clone/features/notifications/data/data_sources/notifications_data_source.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl({required this.notificationDataSource});

  @override
  Future<Either<Failure, List<Notifications>>> getNotifications() async {
    try {
      final notificationModels =
          await notificationDataSource.getNotifications();
      return right(
        notificationModels.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    } on AuthException catch (e) {
      return left(Failure(message: e.message, errorCode: 401));
    } on NetworkException catch (e) {
      return left(Failure(message: e.message, errorCode: 503));
    } catch (e) {
      return left(Failure(message: e.toString(), errorCode: 500));
    }
  }

  @override
  Future<Either<Failure, int>> getUnseenNotificationsCount() async {
    try {
      final count = await notificationDataSource.getUnseenNotificationsCount();
      return right(count);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    } on AuthException catch (e) {
      return left(Failure(message: e.message, errorCode: 401));
    } on NetworkException catch (e) {
      return left(Failure(message: e.message, errorCode: 503));
    } catch (e) {
      return left(Failure(message: e.toString(), errorCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      await notificationDataSource.markNotificationAsRead(notificationId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    } on AuthException catch (e) {
      return left(Failure(message: e.message, errorCode: 401));
    } on NetworkException catch (e) {
      return left(Failure(message: e.message, errorCode: 503));
    } catch (e) {
      return left(Failure(message: e.toString(), errorCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> initializeFcm() async {
    try {
      await notificationDataSource.initializeFcm();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    } on AuthException catch (e) {
      return left(Failure(message: e.message, errorCode: 401));
    } on NetworkException catch (e) {
      return left(Failure(message: e.message, errorCode: 503));
    } catch (e) {
      return left(Failure(message: e.toString(), errorCode: 500));
    }
  }

  @override
  Future<Either<Failure, String?>> getFcmToken() async {
    try {
      final token = await notificationDataSource.getFcmToken();
      return right(token);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    } on AuthException catch (e) {
      return left(Failure(message: e.message, errorCode: 401));
    } on NetworkException catch (e) {
      return left(Failure(message: e.message, errorCode: 503));
    } catch (e) {
      return left(Failure(message: e.toString(), errorCode: 500));
    }
  }

  @override
  Stream<Either<Failure, Notifications>> get notificationStream {
    try {
      return notificationDataSource.notificationStream
          .map((model) {
            return right<Failure, Notifications>(model.toEntity());
          })
          .handleError((error) {
            if (error is ServerException) {
              return left<Failure, Notifications>(
                Failure(message: error.message, errorCode: 500),
              );
            } else if (error is AuthException) {
              return left<Failure, Notifications>(
                Failure(message: error.message, errorCode: 401),
              );
            } else if (error is NetworkException) {
              return left<Failure, Notifications>(
                Failure(message: error.message, errorCode: 503),
              );
            } else {
              return left<Failure, Notifications>(
                Failure(message: error.toString(), errorCode: 500),
              );
            }
          });
    } catch (e) {
      return Stream.value(left(Failure(message: e.toString(), errorCode: 500)));
    }
  }
}
