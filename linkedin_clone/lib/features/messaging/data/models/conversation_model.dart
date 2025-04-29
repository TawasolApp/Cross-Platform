import '../../domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required String id,
    required String lastMessageText,
    required String lastMessageTime,
    required String otherParticipantName,
    required String otherParticipantProfilePic,
    required int unseenCount,
  }) : super(
          id: id,
          lastMessageText: lastMessageText,
          lastMessageTime: lastMessageTime,
          otherParticipantName: otherParticipantName,
          otherParticipantProfilePic: otherParticipantProfilePic,
          unseenCount: unseenCount,
        );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'],
      lastMessageText: json['lastMessage']['text'] ?? '',
      lastMessageTime: json['lastMessage']['sent_at'] ?? '',
      otherParticipantName: json['otherParticipant']['firstName'] ?? '',
      otherParticipantProfilePic: json['otherParticipant']['profilePicture'] ?? '',
      unseenCount: json['unseenCount'] ?? 0,
    );
  }
}
