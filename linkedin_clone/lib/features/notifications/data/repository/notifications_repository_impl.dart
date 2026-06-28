import 'dart:async';
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
  Future<Either<Failure, List<Notifications>>> getNotifications(String id, {int page = 1, int limit = 10}) async {
    try {
      final notificationModels = await notificationDataSource.getNotifications(id, page: page, limit: limit);
      return right(notificationModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, int>> getUnseenNotificationsCount(String id) async {
    try {
      final count = await notificationDataSource.getUnseenNotificationsCount(id);
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
  Future<Either<Failure, void>> markNotificationAsRead(String id, String notificationId) async {
    try {
      await notificationDataSource.markNotificationAsRead(id, notificationId);
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
  Future<Either<Failure, List<Notifications>>> getUnreadNotifications(String id, {int page = 1, int limit = 10}) async {
    try {
      final notificationModels = await notificationDataSource.getUnreadNotifications(id, page: page, limit: limit);
      return right(notificationModels.map((model) => model.toEntity()).toList());
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
    return notificationDataSource.notificationStream.map<Either<Failure, Notifications>>(
      (model) {
        return right(model.toEntity());
      },
    ).handleError(
      (error, stackTrace) {
        // Instead of throwing inside handleError, we manually emit an error
        // But handleError cannot transform the stream type
        // So we have to "catchError" later
      },
    ).transform<Either<Failure, Notifications>>(
      StreamTransformer.fromHandlers(
        handleError: (error, stackTrace, sink) {
          if (error is ServerException) {
            sink.add(left(Failure(message: error.message, errorCode: 500)));
          } else if (error is AuthException) {
            sink.add(left(Failure(message: error.message, errorCode: 401)));
          } else if (error is NetworkException) {
            sink.add(left(Failure(message: error.message, errorCode: 503)));
          } else {
            sink.add(left(Failure(message: error.toString(), errorCode: 500)));
          }
        },
      ),
    );
  }

  @override
  Future<Either<Failure, void>> subscribeToNotifications(String id) async {
    try {
      await notificationDataSource.subscribeToNotifications(id);
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

}