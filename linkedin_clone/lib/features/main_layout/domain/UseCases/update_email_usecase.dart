import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class UpdateEmailUsecase {
  final AuthRepository repository;

  UpdateEmailUsecase(this.repository);

  Future<Either<Failure, void>> call(String newEmail, String password) async {
    return await repository.updateEmail(newEmail, password);
  }

}
