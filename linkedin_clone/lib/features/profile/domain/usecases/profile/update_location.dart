import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateLocationUseCase implements UseCase<void, LocationParams> {
  final ProfileRepository repository;

  UpdateLocationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LocationParams params) async {
    final profileResult = await repository.getProfile(params.userId);

    return profileResult.fold((failure) => left(failure), (profile) {
      final updatedProfile = profile.copyWith(location: params.location);
      return repository.updateProfile(updatedProfile);
    });
  }
}

class LocationParams {
  final String userId;
  final String? location;

  LocationParams({required this.userId, required this.location});
}
