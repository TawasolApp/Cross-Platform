import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteHeadlineUseCase implements UseCase<void, NoParams> {
  final ProfileRepository repository;

  DeleteHeadlineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.deleteHeadline();
  }
}
