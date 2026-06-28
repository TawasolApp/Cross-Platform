import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class UpdateExperienceUseCase implements UseCase<void, ExperienceUpdateParams> {
  final ProfileRepository repository;

  UpdateExperienceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ExperienceUpdateParams params) {
    return repository.updateWorkExperience(
      params.experienceId,
      params.experience,
    );
  }
}

class ExperienceUpdateParams {
  final String experienceId;
  final Experience experience;

  ExperienceUpdateParams({
    required this.experienceId,
    required this.experience,
  });
}
