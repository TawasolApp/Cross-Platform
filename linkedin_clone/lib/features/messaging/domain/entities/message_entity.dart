import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String conversationId;
  final String messageText;
  final List<String> media;
  final String status;
  final String dateTime;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.conversationId,
    required this.messageText,
    required this.media,
    required this.status,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        conversationId,
        messageText,
        media,
        status,
        dateTime,
      ];
}
