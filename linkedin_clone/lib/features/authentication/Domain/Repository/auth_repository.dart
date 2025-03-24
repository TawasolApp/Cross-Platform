import 'package:linkedin_clone/core/errors/failures.dart'; 
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';

abstract interface class AuthRepository {

  Future<Either<Failure,UserEntity>> login(String email, String password);
  Future<Either<Failure,UserEntity>> register(String email, String password,String recaptchaToken);
}