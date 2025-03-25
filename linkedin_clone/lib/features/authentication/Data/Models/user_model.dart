

import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String token,
  }) : super(
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(

      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

}