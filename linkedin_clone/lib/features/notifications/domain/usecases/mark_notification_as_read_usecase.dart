import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationAsReadUseCase implements UseCase<void, MarkNotificationAsReadParams> {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationAsReadParams params) async {
    return await notificationRepository.markNotificationAsRead(params.companyId, params.notificationId);
  }
}

class MarkNotificationAsReadParams {
  final String companyId;
  final String notificationId;

  MarkNotificationAsReadParams({
    required this.companyId,
    required this.notificationId,
  });
}