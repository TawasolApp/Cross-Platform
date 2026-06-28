import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';

class PeopleYouMayKnowUserModel extends PeopleYouMayKnowUserEntity {
  PeopleYouMayKnowUserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.headLine,
    required super.profileImageUrl,
    required super.headerImageUrl,
  });

  factory PeopleYouMayKnowUserModel.fromJson(Map<String, dynamic> json) {
    return PeopleYouMayKnowUserModel(
      userId: json['userId'] ?? '0',
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? '',
      profileImageUrl: json['profilePicture'] ?? 'notavailable',
      headerImageUrl: json['coverPhoto'] ?? 'notavailable',
      headLine: json['headline'] ?? 'notavailable',
    );
  }
}
