import '../../domain/entities/connections_user_entity.dart';

class ConnectionsUserModel extends ConnectionsUserEntity {
  ConnectionsUserModel({
    required super.userId,
    required super.userName,
    required super.headLine,
    required super.time,
    required super.profilePicture,
    // required super.isOnline,  ///feature should be disabled until implemented by backend
  });

  factory ConnectionsUserModel.fromJson(Map<String, dynamic> json) {
    return ConnectionsUserModel(
      userId: json['userId'] ?? '0',
      userName: json['username'] ?? 'Unknown',
      profilePicture: json['profilePicture'] ?? 'notavailable',
      headLine: json['headline'] ?? 'Unknown',
      time: json['createdAt'] ?? 'Unknown',
      //  isOnline: json['connectionStatus']  ?? false,
    );
  }
}
