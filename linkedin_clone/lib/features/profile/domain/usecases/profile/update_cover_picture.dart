import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class UpdateCoverPictureUseCase implements UseCase<void, CoverPictureParams> {
  final ProfileRepository repository;

  UpdateCoverPictureUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CoverPictureParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(coverPhoto: params.coverPhoto);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class CoverPictureParams {
  final String userId;
  final String? coverPhoto;

  CoverPictureParams({required this.userId, required this.coverPhoto});
}
