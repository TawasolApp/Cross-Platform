import 'package:equatable/equatable.dart';

class Notifications extends Equatable {
  final String notificationId;
  final String userName;
  final String profilePicture;
  final String referenceId;
  final String rootItemId;
  final String senderType; // 'User' or 'Company'
  final String type; // 'React', 'Comment', 'UserConnection', 'Message'
  final String content;
  final bool isRead;
  final DateTime timestamp;

  const Notifications({
    required this.notificationId,
    required this.userName,
    required this.profilePicture,
    required this.referenceId,
    required this.rootItemId,
    required this.senderType,
    required this.type,
    required this.content,
    required this.isRead,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    notificationId,
    userName,
    profilePicture,
    referenceId,
    rootItemId,
    senderType,
    type,
    content,
    isRead,
    timestamp,
  ];
}