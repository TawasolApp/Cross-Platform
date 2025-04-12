import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.login(email, password);

      //Save token after API success
      await TokenService.saveToken(userModel.token);
      return Right(userModel as UserEntity);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String recaptchaToken,
  ) async {
    try {
      final userModel = await remoteDataSource.register(
        firstName,
        lastName,
        email,
        password,
        recaptchaToken,
      );

      // Save token after successful registration
      await TokenService.saveToken(userModel.token);

      return Right(userModel as UserEntity);
    } catch (e) {
      print(firstName);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail(
    String email,
    String type,
  ) async {
    try {
      await remoteDataSource.resendVerificationEmail(email, type);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle(String idToken) async {
    try {
      await remoteDataSource.loginWithGoogle(idToken);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(
    String email,
    String password,
  ) async {
    try {
      await remoteDataSource.deleteAccount(email, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(
    String newEmail,
    String password,
  ) async {
    try {
      await remoteDataSource.updateEmail(newEmail, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(
    String email,
    String verificationCode,
  ) {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}
