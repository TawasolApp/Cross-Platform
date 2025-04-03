import 'package:linkedin_clone/features/company/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.username,
    required super.profilePicture,
    required super.headline
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      username: json['username'],
      profilePicture: json['profilePicture'] ?? "", 
      headline: json['headline']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': username,
      'profile_image_url': profilePicture,
      'headline':headline
    };
  }
}
