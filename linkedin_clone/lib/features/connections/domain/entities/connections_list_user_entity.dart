class ConnectionsListUserEntity {
  final String userId;
  final String userName;
  final String headLine;
  final String connectionTime;
  final String userProfileImage;
  //final bool isOnline;
  
  ConnectionsListUserEntity({
    required this.userId,
    required this.userName,
    required this.headLine,
    required this.connectionTime,
    required this.userProfileImage,
   // required this.isOnline,
  });

  factory ConnectionsListUserEntity.fromJson(Map<String, dynamic> json) {
    return ConnectionsListUserEntity(
      userId: json['userId'],
      userName: json['username'],
      headLine: json['headline'],
      userProfileImage: json['profilePicture'],
      connectionTime: json['createdAt'],
     // isOnline: json['connectionStatus'],


    );
  }
}