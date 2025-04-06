import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class UpdateIndustryUseCase implements UseCase<void, IndustryParams> {
  final ProfileRepository repository;

  UpdateIndustryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(IndustryParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(industry: params.industry);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class IndustryParams {
  final String userId;
  final String? industry;

  IndustryParams({required this.userId, required this.industry});
}
