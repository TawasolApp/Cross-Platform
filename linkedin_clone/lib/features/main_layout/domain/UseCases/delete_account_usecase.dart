
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository repository;

  DeleteAccountUsecase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.deleteAccount(email, password);
  }

}
