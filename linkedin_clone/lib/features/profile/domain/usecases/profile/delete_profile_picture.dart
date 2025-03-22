import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteProfilePicture implements UseCase<void, String> {
  final ProfileRepository repository;

  DeleteProfilePicture(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repository.deleteProfilePicture();
  }
}
