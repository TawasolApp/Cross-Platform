import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateIndustryUseCase implements UseCase<void, String> {
  final ProfileRepository repository;

  UpdateIndustryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String? industry) {
    return repository.updateProfile(
      name: null,
      profilePictureUrl: null,
      coverPhoto: null,
      resume: null,
      headline: null,
      bio: null,
      location: null,
      industry: industry
    );
  }
}
