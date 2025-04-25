import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class GetUnseenNotificationsCountUseCase implements UseCase<int, NoParams> {
  final NotificationRepository notificationRepository;

  GetUnseenNotificationsCountUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await notificationRepository.getUnseenNotificationsCount();
  }
}
