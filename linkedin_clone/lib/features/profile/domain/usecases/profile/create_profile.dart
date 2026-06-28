import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import '../../repositories/profile_repository.dart';
import '../../entities/profile.dart';

class CreateProfileUseCase implements UseCase<void, Profile> {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Profile profile) {
    return repository.createProfile(profile);
  }
}
