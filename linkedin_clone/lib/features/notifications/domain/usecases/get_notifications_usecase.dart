import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';
class GetNotificationsUseCase
    implements UseCase<List<Notifications>, GetNotificationsParams> {
  final NotificationRepository notificationRepository;

  GetNotificationsUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, List<Notifications>>> call(GetNotificationsParams params) async {
    return await notificationRepository.getNotifications(
      params.id,
      page: params.page,
      limit: params.limit,
    );
  }
}
class GetNotificationsParams {
  final String id;
  final int page;
  final int limit;

  GetNotificationsParams({
    required this.id,
    this.page = 1,
    this.limit = 10,
  });
}