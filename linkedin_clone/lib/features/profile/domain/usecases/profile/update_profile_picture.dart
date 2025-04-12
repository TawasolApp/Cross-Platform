import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfilePictureUseCase
    implements UseCase<void, ProfilePictureParams> {
  final ProfileRepository repository;

  UpdateProfilePictureUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ProfilePictureParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(
        profilePicture: params.profilePicture,
      );
      return repository.updateProfile(updatedProfile);
    });
  }
}

class ProfilePictureParams {
  final String userId;
  final String? profilePicture;

  ProfilePictureParams({required this.userId, required this.profilePicture});
}
