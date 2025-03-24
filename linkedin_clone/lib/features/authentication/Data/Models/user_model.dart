

import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    required String password,
    required String name,
    required String token,
  }) : super(
          id: id,
          email: email,
          password: password,
          name: name,
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'token': token,
    };
  }

}