import '../../domain/entities/connections_user_entity.dart';

class ConnectionsUserModel extends ConnectionsUserEntity {
  ConnectionsUserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.headLine,
    required super.time,
    required super.profilePicture,
    // required super.isOnline,  ///feature should be disabled until implemented by backend
  });

  factory ConnectionsUserModel.fromJson(Map<String, dynamic> json) {
    return ConnectionsUserModel(
      userId: json['userId'] ?? '0',
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'] ?? 'notavailable',
      headLine: json['headline'] ?? '',
      time: json['createdAt'] ?? '',
      //  isOnline: json['connectionStatus']  ?? false,
    );
  }
}
