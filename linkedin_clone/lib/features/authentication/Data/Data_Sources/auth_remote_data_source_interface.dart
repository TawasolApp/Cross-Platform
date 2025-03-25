import 'package:linkedin_clone/features/authentication/Data/Models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String firstName, String lastName, String email, String password, String recaptchaToken);
  Future<void> forgotPassword(String email);
  Future<void> resendVerificationEmail(String email);
  Future<void> loginWithGoogle(String idToken);
}
