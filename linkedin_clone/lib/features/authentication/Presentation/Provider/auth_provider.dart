import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthProvider with ChangeNotifier {
//Login use case instance

final LoginUseCase loginUseCase;
final ForgotPassUseCase forgotPassUseCase;
UserEntity? _userEntity;

void setUserEntity(UserEntity? userEntity) {
  _userEntity = userEntity;
  notifyListeners();
}


String? _token;

String? _errorMessage;
String? _email;
bool _isLoading = false;

String? get token => _token;
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
  print("Login result: $result");

  return result.fold(
    (failure) {
      _errorMessage = failure.message;
      _isLoading = false;
      notifyListeners();
      return false;
    },
    (userEntity) {
      _email = email;
      setUserEntity(userEntity);
      _isLoading = false;
      notifyListeners();
      return true;
    },
  );
}

Future<bool> forgotPassword(String email)async {
  
  final result = await forgotPassUseCase.call(email);

  return result.fold(
    (failure) {
      _errorMessage = failure.message;
      _isLoading = false;
      notifyListeners();
      return false;
    },
    (_) {
      _userEntity=userEntity;
      _isLoading = false;
      notifyListeners();
      return true;
    },
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

  Future<void> Logout() async{

    try{
      await TokenService.removeToken();
      await TokenService.removeRefreshToken();
      clearUserData();
      notifyListeners();


    }
    catch(e){
      print("Logout error: $e");
    }

  }
  void clearUserData() {
    _userEntity = null;
    _email = null;
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  }

}





