class ConversationEntity {
  final String id;
  final String lastMessageText;
  final String lastMessageTime;
  final String otherParticipantName;
  final String otherParticipantProfilePic;
  final int unseenCount;

  ConversationEntity({
    required this.id,
    required this.lastMessageText,
    required this.lastMessageTime,
    required this.otherParticipantName,
    required this.otherParticipantProfilePic,
    required this.unseenCount,
  });
}
