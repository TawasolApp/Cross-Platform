import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/user_preview_entity.dart';

class ConversationEntity {
  final String id;
  final MessageEntity lastMessage;
  final int unseenCount;
  final UserPreviewEntity otherParticipant;

  ConversationEntity({
    required this.id,
    required this.lastMessage,
    required this.unseenCount,
    required this.otherParticipant,
  });
}