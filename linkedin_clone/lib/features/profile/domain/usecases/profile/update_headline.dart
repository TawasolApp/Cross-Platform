import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateHeadlineUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateHeadlineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String headline) {
    return repository.updateProfile(
      name: null,
      profilePictureUrl: null,
      coverPhoto: null,
      resume: null,
      headline: headline,
      bio: null,
      location: null,
      industry: null
    );
  }
}
