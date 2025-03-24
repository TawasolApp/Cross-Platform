import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';

//import '../../domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
//Login use case instance

final LoginUseCase loginUseCase;

late UserEntity _userEntity;
String? _errorMessage;
bool _isLoading = false;

UserEntity? get userEntity => _userEntity;  
String? get errorMessage => _errorMessage;
bool get isLoading => _isLoading;
AuthProvider(this.loginUseCase);

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


}





