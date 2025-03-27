import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateNameUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateNameUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String? name) {
    return repository.updateProfile(
      name: name,
      profilePictureUrl: null,
      coverPhoto: null,
      resume: null,
      headline: null,
      bio: null,
      location: null,
      industry: null
    );
  }
}
