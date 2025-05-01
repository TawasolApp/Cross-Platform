import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsStreamUseCase
    implements UseCase<Stream<Either<Failure, Notifications>>, NoParams> {
  final NotificationRepository notificationRepository;

  GetNotificationsStreamUseCase(this.notificationRepository);

  @override
  Future<Either<Failure, Stream<Either<Failure, Notifications>>>> call(NoParams params) async {
    return Right(notificationRepository.notificationStream);
  }
}