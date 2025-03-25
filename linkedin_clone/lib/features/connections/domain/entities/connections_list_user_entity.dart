class ConnectionsListUserEntity {
  final String userId;
  final String userName;
  final String headLine;
  final String connectionTime;
  final String profilePicture;
  //final bool isOnline;

  ConnectionsListUserEntity({
    required this.userId,
    required this.userName,
    required this.headLine,
    required this.connectionTime,
    required this.profilePicture,
    // required this.isOnline,
  });

  factory ConnectionsListUserEntity.fromJson(Map<String, dynamic> json) {
    return ConnectionsListUserEntity(
      userId: json['userId'],
      userName: json['username'],
      headLine: json['headline'],
      profilePicture: json['profilePicture'],
      connectionTime: json['createdAt'],

      // isOnline: json['connectionStatus'],
    );
  }
}
