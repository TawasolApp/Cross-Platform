import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class AddExperienceUseCase implements UseCase<void, Experience> {
  final ProfileRepository repository;

  AddExperienceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Experience experience) {
    return repository.addWorkExperience(experience);
  }
}
