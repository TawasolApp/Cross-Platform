import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';

class DeleteExperienceUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  DeleteExperienceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String experienceId) {
    return repository.deleteWorkExperience(experienceId);
  }
}
