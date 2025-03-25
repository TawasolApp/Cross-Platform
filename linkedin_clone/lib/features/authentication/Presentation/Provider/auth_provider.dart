import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import '../../domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
//Login use case instance

final LoginUseCase loginUseCase;
final ForgotPassUseCase forgotPassUseCase;

late UserEntity _userEntity;

String? _errorMessage;
String? _email;
bool _isLoading = false;

UserEntity? get userEntity => _userEntity;  
String? get errorMessage => _errorMessage;
bool get isLoading => _isLoading;
String? get email => _email;
AuthProvider(this.loginUseCase,this.forgotPassUseCase);
void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

Future<bool> login(String email, String password) async {

  final result = await loginUseCase.call(email, password);

  return result.fold(
    (failure) {
      _errorMessage = failure.message;
      _isLoading = false;
      notifyListeners();
      return false;
    },
    (userEntity) {
      _userEntity=userEntity;
      _isLoading = false;
      notifyListeners();
      return true;
    },
  );
}

Future<bool> forgotPassword(String email)async {
  
  final result = await forgotPassUseCase.call(email);
  return result.fold(
    (failure)=>false,
    (_)=>true,
  );  
}


Future<bool> loginWithGoogle() async {
  try {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) return false;

    final result = await loginUseCase.loginWithGoogle(idToken);

    return result.isRight();
  } catch (e) {
    print("Google sign-in error: $e");
    return false;
  }
}

}





