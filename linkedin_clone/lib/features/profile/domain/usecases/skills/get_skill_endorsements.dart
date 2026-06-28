import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';

class GetSkillEndorsements {
  final ProfileRepository repository;

  GetSkillEndorsements(this.repository);

  Future<Either<Failure, List<Endorsement>>> call(
      GetSkillEndorsementsParams params) async {
    return await repository.getSkillEndorsements(params.userId, params.skillName);
  }
}

class GetSkillEndorsementsParams {
  final String userId;
  final String skillName;

  GetSkillEndorsementsParams({required this.userId, required this.skillName});
}