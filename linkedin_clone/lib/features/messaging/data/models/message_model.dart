import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.conversationId,
    required super.messageText,
    required super.media,
    required super.status, 
    required super.dateTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      senderId: json['senderId'] as String,
      conversationId: json['conversationId'] as String,
      messageText: json['messageText'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      status: json['status'] as String? ?? 'sent',
      dateTime: json['dateTime'] as String, 
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'conversationId': conversationId,
      'messageText': messageText,
      'media': media,
      'status': status,
      'dateTime': dateTime,
    };
  }
}
