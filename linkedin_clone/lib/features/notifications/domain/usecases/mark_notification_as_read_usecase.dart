import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, void>> call(String notificationId) async {
    return await notificationRepository.markNotificationAsRead(notificationId);
  }
}
