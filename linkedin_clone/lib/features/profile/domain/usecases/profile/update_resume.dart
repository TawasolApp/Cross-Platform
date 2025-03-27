import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateResumeUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateResumeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String? resume) {
    return repository.updateProfile(
      name: null,
      profilePictureUrl: null,
      coverPhoto: null,
      resume: resume,
      headline: null,
      bio: null,
      location: null,
      industry: null
    );
  }
}
