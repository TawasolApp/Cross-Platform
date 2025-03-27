import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateLocationUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateLocationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String location) {
    return repository.updateProfile(
      name: null,
      profilePictureUrl: null,
      coverPhoto: null,
      resume: null,
      headline: null,
      bio: null,
      location: location,
      industry: null,
    );
  }
}
