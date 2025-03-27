import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import '../../repositories/profile_repository.dart';
import '../../entities/profile.dart';

class GetProfileUseCase implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) {
    return repository.getProfile();
  }
}
