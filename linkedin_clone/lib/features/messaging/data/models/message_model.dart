import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.recieverId,
    required super.conversationId,
    required super.text,
    required super.media,
    required super.status, 
    required super.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      senderId: json['senderId'] as String,
      recieverId: json['receiverId'] as String? ?? '',
      conversationId: json['conversationId'] as String,
      text: json['text'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      status: json['status'] as String? ?? 'sent',
      sentAt: json['sentAt'] as String, 
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'conversationId': conversationId,
      'text': text,
      'media': media,
      'status': status,
      'sentAt': sentAt,
    };
  }
}
