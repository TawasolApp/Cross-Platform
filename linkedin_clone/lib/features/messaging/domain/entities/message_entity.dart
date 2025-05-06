import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String recieverId;
  final String conversationId;
  final String text;
  final List<String> media;
  final String status;
  final String sentAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.recieverId,
    required this.conversationId,
    required this.text,
    required this.media,
    required this.status,
    required this.sentAt,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        conversationId,
        text,
        media,
        status,
        sentAt,
      ];
}
