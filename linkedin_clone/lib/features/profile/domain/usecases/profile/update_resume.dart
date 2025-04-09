import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class UpdateResumeUseCase implements UseCase<void, ResumeParams> {
  final ProfileRepository repository;

  UpdateResumeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResumeParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(resume: params.resume);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class ResumeParams {
  final String userId;
  final String? resume;

  ResumeParams({required this.userId, required this.resume});
}
