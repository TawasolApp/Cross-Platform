import 'package:linkedin_clone/features/company/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    super.profilePicture,
    super.headline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
      headline: json['headline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': firstName,
      'lastName': lastName,
      'profile_image_url': profilePicture,
      'headline': headline,
    };
  }
}
