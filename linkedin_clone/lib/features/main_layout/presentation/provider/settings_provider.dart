import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/change_password_usecase.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/delete_account_usecase.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/update_email_usecase.dart';



class SettingsProvider with ChangeNotifier {


final ChangePasswordUseCase changePasswordUseCase;
final UpdateEmailUsecase updateEmailUsecase;
final DeleteAccountUsecase deleteAccountUsecase;

SettingsProvider(this.changePasswordUseCase,this.updateEmailUsecase,this.deleteAccountUsecase);

String? _errorMessage;
String? _email;
String newPassword = '';
String currentPassword = '';
String password = '';
String newEmail = '';



String? get errorMessage => _errorMessage;
String? get email => _email;
String get newPasswordValue => newPassword;
String get currentPasswordValue => currentPassword;
String get passwordValue => password;
String get newEmailValue => newEmail;


  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setNewPassword(String value) {
    newPassword = value;
    notifyListeners();
  }

  void setCurrentPassword(String value) {
    currentPassword = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

void setEmail(String value) {
    newEmail = value;
    notifyListeners();
  }


  Future<bool> changePassword(String currentPassword,String newPassword) async { 
    
    final result = await changePasswordUseCase.call(currentPassword, newPassword);

    return result.fold(
      (failure){
        //password not updated 
        //400 incorrect- 404 user not found etc..
        _errorMessage=failure.message;
        notifyListeners();
        return false;
      },
      (_)
      {
        notifyListeners();
        return true;
      },

    );

  }


    Future<bool> updateEmail(String newEmail,String password) async { 
    
    final result = await updateEmailUsecase.call(newEmail, password);

    return result.fold(
      (failure){
        //email not updated
        //400 incorrect- 404 user not found etc..
        _errorMessage=failure.message;
        notifyListeners();
        return false;
      },
      (_)
      {
        notifyListeners();
        return true;
      },

    );

  }

    Future<bool> deleteAccount(String email,String password) async { 
    
    final result = await deleteAccountUsecase.call(email, password);

    return result.fold(
      (failure){
        //Account deleted
        //400 incorrect- 404 user not found etc..
        _errorMessage=failure.message;
        notifyListeners();
        return false;
      },
      (_)
      {
        notifyListeners();
        return true;
      },

    );

  }




}





