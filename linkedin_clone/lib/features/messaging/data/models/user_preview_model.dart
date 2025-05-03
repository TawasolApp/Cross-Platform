import 'package:linkedin_clone/features/messaging/domain/entities/user_preview_entity.dart';

class UserPreviewModel extends UserPreviewEntity {
  UserPreviewModel({
    required String id,
    required String firstName,
    required String lastName,
    required String profilePicture,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          profilePicture: profilePicture,
        );

  factory UserPreviewModel.fromJson(Map<String, dynamic> json) {
    return UserPreviewModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}
