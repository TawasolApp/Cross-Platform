


import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String firstName,String lastName,String email, String password,String recaptchaToken) async {
    return await repository.register(firstName,lastName,email, password,recaptchaToken);
  }
}
