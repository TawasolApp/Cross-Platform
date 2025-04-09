import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBioUseCase implements UseCase<void, BioParams> {
  final ProfileRepository repository;

  UpdateBioUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(BioParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(bio: params.bio);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class BioParams {
  final String userId;
  final String? bio;

  BioParams({required this.userId, required this.bio});
}
