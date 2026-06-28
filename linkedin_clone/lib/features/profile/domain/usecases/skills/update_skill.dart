import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
class UpdateSkillUseCase implements UseCase<void, UpdateSkillParams> {
  final ProfileRepository repository;

  UpdateSkillUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSkillParams params) {
    return repository.updateSkill(params.skillName, params.skill);
  }
}

class UpdateSkillParams {
  final String skillName;
  final Skill skill;

  UpdateSkillParams({required this.skillName, required this.skill});
}
