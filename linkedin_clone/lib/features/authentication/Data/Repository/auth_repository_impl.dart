import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/mock_auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
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
  Future<Either<Failure, UserEntity>> register(String email, String password, String recaptchaToken) async {
    try {
      final userModel = await remoteDataSource.register(email, password, recaptchaToken);

      // Save token after successful registration
      await TokenService.saveToken(userModel.token);

      return Right(userModel as UserEntity);
    } catch (e) {
      return Left(ServerFailure());
    }
  }


 
}
