import 'package:linkedin_clone/core/errors/failures.dart'; 
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';

abstract interface class AuthRepository {

  Future<Either<Failure,UserEntity>> login(String email, String password);
  Future<Either<Failure,UserEntity>> register(String firstName,String lastName,String email, String password,String recaptchaToken);
  Future<Either<Failure,void>> forgotPassword(String email);
  Future<Either<Failure,void>> resendVerificationEmail(String email);
  Future<Either<Failure, void>> loginWithGoogle(String idToken);
  Future<Either<Failure, void>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, void>> updateEmail(String email, String password);
  Future<Either<Failure, void>> verifyEmail(String email, String verificationCode);
  Future<Either<Failure, void>> deleteAccount(String email, String password);

}