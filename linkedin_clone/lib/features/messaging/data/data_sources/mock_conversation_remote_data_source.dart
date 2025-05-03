import 'package:linkedin_clone/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/data/models/conversation_model.dart';
import 'package:linkedin_clone/features/messaging/data/models/message_model.dart';
import 'package:linkedin_clone/features/messaging/data/models/user_preview_model.dart';

class MockConversationDataSource implements ConversationRemoteDataSource {
  @override
  Future<List<ConversationModel>> fetchConversations() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    return [
      ConversationModel(
        id: 'convo1',
        lastMessage: MessageModel(
          id: 'msg1',
          senderId: 'user1',
          conversationId: 'convo1',
          messageText: 'Hey, how are you?',
          media: [],
          status: 'Sent',
          dateTime: '2025-04-26T16:40:12.772Z',
        ),
        unseenCount: 2,
        otherParticipant: UserPreviewModel(
          id: 'user2',
          firstName: 'Jane',
          lastName: 'Doe',
          profilePicture: 'https://avatars.githubusercontent.com/u/24987750',
        ),
      ),
      ConversationModel(
        id: 'convo2',
        lastMessage: MessageModel(
          id: 'msg2',
          senderId: 'user3',
          conversationId: 'convo2',
          messageText: 'Let’s meet tomorrow.',
          media: [],
          status: 'Sent',
          dateTime: '2025-04-25T14:15:00.000Z',
        ),
        unseenCount: 0,
        otherParticipant: UserPreviewModel(
          id: 'user2',
          firstName: 'Jane',
          lastName: 'Doe',
          profilePicture: 'https://avatars.githubusercontent.com/u/24987750',
        ),
      ),
    ];
  }

  @override
  Future<List<MessageModel>> getChat(String conversationId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    return [
      MessageModel(
        id: 'msg1',
        senderId: 'user1',
        conversationId: conversationId,
        messageText: 'Hey, how are you?',
        media: [],
        status: 'Sent',
        dateTime: '2025-04-26T16:40:12.772Z',
      ),
      MessageModel(
        id: 'msg2',
        senderId: 'user2',
        conversationId: conversationId,
        messageText: 'I am good, thanks! How about you?',
        media: [],
        status: 'Received',
        dateTime: '2025-04-26T16:41:00.000Z',
      ),
    ];
  }
}