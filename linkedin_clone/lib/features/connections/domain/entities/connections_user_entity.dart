class ConnectionsUserEntity {
  final String userId;
  final String userName;
  final String headLine;
  final String time;
  final String profilePicture;
  //final bool isOnline;

  ConnectionsUserEntity({
    required this.userId,
    required this.userName,
    required this.headLine,
    required this.time,
    required this.profilePicture,
    // required this.isOnline,
  });

  factory ConnectionsUserEntity.fromJson(Map<String, dynamic> json) {
    return ConnectionsUserEntity(
      userId: json['userId'],
      userName: json['username'],
      headLine: json['headline'],
      profilePicture: json['profilePicture'],
      time: json['createdAt'],

      // isOnline: json['connectionStatus'],
    );
  }
}
