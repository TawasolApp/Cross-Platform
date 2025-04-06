import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class UpdateHeadlineUseCase implements UseCase<void, HeadlineParams> {
  final ProfileRepository repository;

  UpdateHeadlineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(HeadlineParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(headline: params.headline);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class HeadlineParams {
  final String userId;
  final String? headline;

  HeadlineParams({required this.userId, required this.headline});
}
