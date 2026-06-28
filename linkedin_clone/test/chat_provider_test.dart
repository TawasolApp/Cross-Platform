import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/chat_provider.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:mockito/mockito.dart';

import 'mocks/messaging_mocks.mocks.dart';

void main() {
  late MockGetChatUseCase mockGetChatUseCase;
  late MockMessagingSocketService mockSocketService;
  late ChatProvider chatProvider;

  setUp(() {
    mockGetChatUseCase = MockGetChatUseCase();
    mockSocketService = MockMessagingSocketService();
    chatProvider = ChatProvider(mockGetChatUseCase, mockSocketService);
  });

  test('fetchMessages populates messages from use case', () async {
    // Arrange
    final fakeMessages = [
      MessageEntity(
        id: '1',
        senderId: 'user1',
        recieverId: 'user2',
        conversationId: 'conv1',
        text: 'Hi there',
        media: [],
        status: 'Sent',
        sentAt: DateTime.now().toIso8601String(),
      ),
    ];

    when(mockGetChatUseCase.call('conv1')).thenAnswer((_) async => fakeMessages);

    // Act
    await chatProvider.fetchMessages('conv1');

    // Assert
    expect(chatProvider.messages.length, 1);
    expect(chatProvider.messages.first.text, 'Hi there');
    verify(mockGetChatUseCase.call('conv1')).called(1);
  });

  test('sendTextMessage adds message to local list and calls socket', () {
    // Arrange
    chatProvider.setCurrentUserId('me');
    chatProvider.setConversationId('conv1');

    when(mockSocketService.sendMessage(any)).thenReturn(null);

    // Act
    chatProvider.sendTextMessage('you', 'Test Message');

    // Assert
    expect(chatProvider.messages.first.text, 'Test Message');
    expect(chatProvider.messages.first.senderId, 'me');
    verify(mockSocketService.sendMessage(any)).called(1);
  });

  test('markAllMessagesAsRead updates all message statuses to Read', () {
    // Arrange
    chatProvider.messages = [
      MessageEntity(
        id: '1',
        senderId: 'me',
        recieverId: 'you',
        conversationId: 'conv1',
        text: 'Delivered msg',
        media: [],
        status: 'Delivered',
        sentAt: DateTime.now().toIso8601String(),
      ),
      MessageEntity(
        id: '2',
        senderId: 'me',
        recieverId: 'you',
        conversationId: 'conv1',
        text: 'Sent msg',
        media: [],
        status: 'Sent',
        sentAt: DateTime.now().toIso8601String(),
      ),
    ];

    // Act
    chatProvider.markAllMessagesAsRead();

    // Assert
    expect(chatProvider.messages.every((msg) => msg.status == 'Read'), isTrue);
  });
}
