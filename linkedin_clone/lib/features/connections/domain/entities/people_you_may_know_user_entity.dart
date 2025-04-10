class PeopleYouMayKnowUserEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String profileImageUrl;
  final String headerImageUrl;

  PeopleYouMayKnowUserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.profileImageUrl,
    required this.headerImageUrl,
  });

  factory PeopleYouMayKnowUserEntity.fromJson(Map<String, dynamic> json) {
    return PeopleYouMayKnowUserEntity(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      headLine: json['headline'],
      profileImageUrl: json['profilePicture'],
      headerImageUrl: json['coverPhoto'],
    );
  }
}
