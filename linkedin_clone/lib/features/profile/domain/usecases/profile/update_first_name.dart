import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateFirstNameUseCase implements UseCase<void, FirstNameParams> {
  final ProfileRepository repository;

  UpdateFirstNameUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(FirstNameParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(firstName: params.firstName);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class FirstNameParams {
  final String userId;
  final String firstName;

  FirstNameParams({required this.userId, required this.firstName});
}
