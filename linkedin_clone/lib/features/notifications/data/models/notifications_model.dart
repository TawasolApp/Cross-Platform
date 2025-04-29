// features/notifications/data/models/notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';

class NotificationsModel {
  final String notificationId;
  final String userName;
  final String profilePicture;
  final String referenceId;
  final String rootItemId; // 'Post', 'Comment', 'Message', etc.
  final String senderType; // 'User' or 'Company'
  final String type; // 'React', 'Comment', 'UserConnection', 'Message'
  final String content;
  final bool isRead;
  final DateTime timestamp;

  NotificationsModel({
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

  factory NotificationsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationsModel(
      notificationId: doc.id,
      userName: data['userName'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      referenceId: data['referenceId'] ?? '',
      rootItemId: data['rootItemId'] ?? '',
      senderType: data['senderType'] ?? 'User',
      type: data['type'] ?? 'Message',
      content: data['content'] ?? '',
      isRead: data['isRead'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  factory NotificationsModel.fromFcm(RemoteMessage message) {
    return NotificationsModel(
      notificationId:
          message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userName:
          message.notification?.title ??
          message.data['userName'] ??
          'New Notification',
      profilePicture: message.data['profilePicture'] ?? '',
      referenceId: message.data['referenceId'] ?? '',
      rootItemId: message.data['rootItemId'] ?? '',
      senderType: message.data['senderType'] ?? 'User',
      type: message.data['type'] ?? 'Message',
      content: message.notification?.body ?? message.data['content'] ?? '',
      isRead: false,
      timestamp: DateTime.now(),
    );
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      notificationId: json['notificationId'] ?? '',
      userName: json['userName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      referenceId:
          json['refrenceId'] ??
          json['referenceId'] ??
          '', // Handle both spellings
      rootItemId: json['rootItemId'] ?? '',
      senderType: json['senderType'] ?? 'User',
      type: json['type'] ?? 'Message',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userName': userName,
      'profilePicture': profilePicture,
      'referenceId': referenceId,
      'rootItemId': rootItemId,
      'senderType': senderType,
      'type': type,
      'content': content,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'profilePicture': profilePicture,
      'referenceId': referenceId,
      'rootItemId': rootItemId,
      'senderType': senderType,
      'type': type,
      'content': content,
      'isRead': isRead,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  Map<String, dynamic> toFcmPayload() {
    return {
      'notification': {'title': 'New $type', 'body': content},
      'data': {
        'notificationId': notificationId,
        'userName': userName,
        'profilePicture': profilePicture,
        'referenceId': referenceId,
        'rootItemId': rootItemId,
        'senderType': senderType,
        'type': type,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    };
  }

  Notifications toEntity() {
    return Notifications(
      notificationId: notificationId,
      userName: userName,
      profilePicture: profilePicture,
      referenceId: referenceId,
      rootItemId: rootItemId,
      senderType: senderType,
      type: type,
      content: content,
      isRead: isRead,
      timestamp: timestamp,
    );
  }
}
