


import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
