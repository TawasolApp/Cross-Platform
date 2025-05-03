import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class InitializeFcmUseCase implements UseCase<void, NoParams> {
  final NotificationRepository notificationRepository;

  InitializeFcmUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await notificationRepository.initializeFcm();
  }
}