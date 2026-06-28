import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';

@GenerateMocks([
  LoginUseCase,
  ForgotPassUseCase,
])
void main() {}
