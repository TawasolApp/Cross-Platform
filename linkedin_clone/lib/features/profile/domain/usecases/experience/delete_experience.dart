import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';

class DeleteExperience implements UseCase<void, String> {
  final ProfileRepository repository;

  DeleteExperience(this.repository);

  @override
  Future<Either<Failure, void>> call(String experience) {
    return repository.deleteExperience(experience);
  }
}
