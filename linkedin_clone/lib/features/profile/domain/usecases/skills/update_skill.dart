import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';

class UpdateSkill implements UseCase<void, Skill> {
  final ProfileRepository repository;

  UpdateSkill(this.repository);

  @override
  Future<Either<Failure, void>> call(Skill skill) {
    return repository.updateSkill(skill);
  }
}