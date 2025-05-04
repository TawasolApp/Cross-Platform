import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/user_preview_entity.dart';
import 'message_model.dart';
import 'user_preview_model.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required String id,
    required MessageEntity lastMessage,
    required int unseenCount,
    required UserPreviewEntity otherParticipant,
  }) : super(
          id: id,
          lastMessage: lastMessage,
          unseenCount: unseenCount,
          otherParticipant: otherParticipant,
        );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] as String,
      lastMessage: MessageModel.fromJson({
        '_id': json['lastMessage']['_id'],
        'senderId': json['lastMessage']['senderId'],
        'receiverId': json['lastMessage']['receiverId'],
        'conversationId': json['lastMessage']['conversationId'],
        'text': json['lastMessage']['text'],
        'media': json['lastMessage']['media'],
        'status': json['lastMessage']['status'],
        'sentAt': json['lastMessage']['sentAt'],
      }),

      unseenCount: json['unseenCount'] as int,
      otherParticipant: UserPreviewModel.fromJson(json['otherParticipant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lastMessage': (lastMessage as MessageModel).toJson(),
      'unseenCount': unseenCount,
      'otherParticipant': (otherParticipant as UserPreviewModel).toJson(),
    };
  }
}
