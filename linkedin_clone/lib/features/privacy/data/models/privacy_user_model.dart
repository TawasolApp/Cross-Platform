import '../../domain/entities/privacy_user_entity.dart';

class PrivacyUserModel extends PrivacyUserEntity {
  PrivacyUserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.profilePicture,
    // required super.isOnline,  ///feature should be disabled until implemented by backend
  });

  factory PrivacyUserModel.fromJson(Map<String, dynamic> json) {
    return PrivacyUserModel(
      userId: json['userId'] ?? '0',
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'] ?? 'notavailable',
      // isOnline: json['connectionStatus'] ?? false,
    );
  }
}
