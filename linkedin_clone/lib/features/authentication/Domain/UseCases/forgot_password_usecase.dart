


import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class ForgotPassUseCase {
  final AuthRepository repository;

  ForgotPassUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
