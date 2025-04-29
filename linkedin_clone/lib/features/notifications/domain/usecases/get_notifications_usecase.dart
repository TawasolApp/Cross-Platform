import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<Notifications>, String> {
  final NotificationRepository notificationRepository;

  GetNotificationsUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, List<Notifications>>> call(String companyId) async {
    return await notificationRepository.getNotifications(companyId);
  }
}
