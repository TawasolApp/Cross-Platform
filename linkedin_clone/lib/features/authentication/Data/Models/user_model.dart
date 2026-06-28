

import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.token,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(

      token: json['token'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role' : role,
    };
  }

}