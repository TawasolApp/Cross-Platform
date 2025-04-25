import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class GetFcmTokenUseCase implements UseCase<String?, NoParams> {
  final NotificationRepository notificationRepository;

  GetFcmTokenUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await notificationRepository.getFcmToken();
  }
}
