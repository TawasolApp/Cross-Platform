class PrivacyUserEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String profilePicture;
  // final bool isOnline;

  PrivacyUserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,

    required this.profilePicture,
    // required this.isOnline,
  });

  factory PrivacyUserEntity.fromJson(Map<String, dynamic> json) {
    return PrivacyUserEntity(
      userId: json['userId'] ?? '0',
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'] ?? 'notavailable',
      // isOnline: json['connectionStatus'] ?? false,
    );
  }
}
