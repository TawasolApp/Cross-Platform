import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateLastNameUseCase implements UseCase<void, LastNameParams> {
  final ProfileRepository repository;

  UpdateLastNameUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LastNameParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(lastName: params.lastName);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class LastNameParams {
  final String userId;
  final String lastName;

  LastNameParams({required this.userId, required this.lastName});
}
