import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class GetUnreadNotificationsUseCase
    implements UseCase<List<Notifications>, GetUnreadNotificationsParams> {
  final NotificationRepository notificationRepository;

  GetUnreadNotificationsUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, List<Notifications>>> call(GetUnreadNotificationsParams params) async {
    return await notificationRepository.getUnreadNotifications(
      params.id,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetUnreadNotificationsParams {
  final String id;
  final int page;
  final int limit;

  GetUnreadNotificationsParams({
    required this.id,
    required this.page,
    required this.limit,
  });
}