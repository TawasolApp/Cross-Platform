import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/resend_email_usecase.dart';

class RegisterProvider with ChangeNotifier {
  // Registration fields
  final RegisterUseCase registerUsecase;
  final ResendEmailUsecase resendEmailUsecase;
  RegisterProvider({
    required this.registerUsecase,
    required this.resendEmailUsecase,
  });
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  String? _location;
  String? _jobTitle;
  bool _isStudent = false;
  bool _showPasswordStep = false;
  UserEntity? _userEntity;
  String? _errorMessage;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  // Getters
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get password => _password;
  String? get location => _location;
  String? get jobTitle => _jobTitle;
  bool get isStudent => _isStudent;
  bool get showPasswordStep => _showPasswordStep;
  UserEntity? get userEntity => _userEntity;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  //VALIDATION
  bool isValidName(String name) => name.trim().isNotEmpty;

  bool get canContinueFromName =>
      isValidName(firstName ?? "") && isValidName(lastName ?? "");

  bool get isValidEmail =>
      email != null &&
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email!);

  bool get isValidPassword => password != null && password!.trim().length >= 6;

  // Setters

  void setUserEntity(UserEntity? userEntity) {
    _userEntity = userEntity;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setJobTitle(String value) {
    _jobTitle = value;
    notifyListeners();
  }

  void toggleIsStudent() {
    _isStudent = !_isStudent;
    notifyListeners();
  }

  void showPasswordInput() {
    _showPasswordStep = true;
    notifyListeners();
  }

  // You can call this on the last step to finalize
  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String recaptchaToken,
  ) async {
    final result = await registerUsecase.call(
      firstName,
      lastName,
      email,
      password,
      recaptchaToken,
    );
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (userEntity) {
        setUserEntity(userEntity);
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> resendVerificationEmail(String email, String type) async {
    // Call the usecase to resend verification email
    final result = await resendEmailUsecase.call(email, type);
    return result.fold((failure) => false, (_) => true);
  }

  void reset() {
    _firstName = null;
    _lastName = null;
    _email = null;
    _password = null;
    _location = null;
    _jobTitle = null;
    _isStudent = false;
    notifyListeners();
  }
}
