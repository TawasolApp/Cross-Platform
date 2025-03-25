import '../../domain/entities/connections_list_user_entity.dart';
class ConnectionsListUserModel extends ConnectionsListUserEntity {
  ConnectionsListUserModel({
    required super.userId,
    required super.userName,
    required super.headLine,
    required super.connectionTime,
    required super.userProfileImage,
   // required super.isOnline,  ///feature should be disabled until implemented by backend
  });


  factory ConnectionsListUserModel.fromJson(Map<String, dynamic> json) {
    return ConnectionsListUserModel(
      userId: json['userId']?? '0',
      userName: json['username'] ?? 'Unknown',
      userProfileImage: json['profilePicture'] ?? 'notavailable',
      headLine: json['headline']  ?? 'Unknown',
      connectionTime: json['createdAt']  ?? 'Unknown',
    //  isOnline: json['connectionStatus']  ?? false,
    );
  }

}

