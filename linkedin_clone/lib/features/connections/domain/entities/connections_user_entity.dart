class ConnectionsUserEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String time;
  final String profilePicture;
  //final bool isOnline;

  ConnectionsUserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.time,
    required this.profilePicture,
    // required this.isOnline,
  });

  factory ConnectionsUserEntity.fromJson(Map<String, dynamic> json) {
    return ConnectionsUserEntity(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      headLine: json['headline'],
      profilePicture: json['profilePicture'],
      time: json['createdAt'],

      // isOnline: json['connectionStatus'],
    );
  }
}
