import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import '../../repositories/profile_repository.dart';
import '../../entities/profile.dart';

class GetProfileUseCase implements UseCase<Profile, String> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Profile>> call(String userId) {
    return repository.getProfile();
  }
}
