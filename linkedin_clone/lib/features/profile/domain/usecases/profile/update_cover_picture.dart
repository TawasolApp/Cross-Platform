import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateCoverPictureUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateCoverPictureUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String coverPhoto) {
    return repository.updateProfile(
      name: null,
      profilePictureUrl: null,
      coverPhoto: coverPhoto,
      resume: null,
      headline: null,
      bio: null,
      location: null,
      industry: null
    );
  }
}
