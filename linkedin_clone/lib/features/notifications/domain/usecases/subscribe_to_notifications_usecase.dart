import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class SubscribeToNotificationsUseCase {
  final NotificationRepository repository;

  SubscribeToNotificationsUseCase(this.repository);

  // Method to subscribe to notifications on the server
  Future<Either<Failure, void>> call(String companyId) async {
    return await repository.subscribeToNotifications(companyId);
  }

  // Access to the notification stream
  Stream<Either<Failure, Notifications>> get stream =>
      repository.notificationStream;

  // Method to listen to notifications
  StreamSubscription<Either<Failure, Notifications>> listen({
    required void Function(Notifications notification) onNotification,
    required void Function(Failure failure) onFailure,
    void Function()? onDone,
    void Function(Object error)? onError,
  }) {
    // Subscribing to the notification stream from the repository
    return repository.notificationStream.listen(
      (either) {
        // Handling the incoming stream data (either Failure or Notifications)
        either.fold(
          onFailure, // If Failure, invoke the onFailure callback
          onNotification, // If Notifications, invoke the onNotification callback
        );
      },
      onDone: onDone, // Optionally handle when the stream is done
      onError: onError, // Optionally handle errors during stream subscription
    );
  }
}
