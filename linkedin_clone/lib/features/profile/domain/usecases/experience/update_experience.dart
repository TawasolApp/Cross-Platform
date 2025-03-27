import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class UpdateExperienceUseCase implements UseCase<void, Experience> {
  final ProfileRepository repository;

  UpdateExperienceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Experience experience) {
    return repository.updateExperience(experience);
  }
}