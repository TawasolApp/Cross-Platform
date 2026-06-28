import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/conversation_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/user_preview_entity.dart';
import 'package:mockito/mockito.dart';

import 'mocks/messaging_mocks.mocks.dart';

void main() {
  late MockGetConversationsUseCase mockGetConversationsUseCase;
  late ConversationListProvider provider;

  final testMessage = MessageEntity(
    id: 'm1',
    senderId: 'user1',
    recieverId: 'user2',
    conversationId: 'c1',
    text: 'Hello',
    media: [],
    status: 'Sent',
    sentAt: DateTime.now().toIso8601String(),
  );

  final testUser = const UserPreviewEntity(
    id: 'user2',
    firstName: 'Test',
    lastName: 'User',
    profilePicture: '',
  );

  setUp(() {
    mockGetConversationsUseCase = MockGetConversationsUseCase();
    provider = ConversationListProvider(mockGetConversationsUseCase);
  });

  test('fetchConversations populates the conversation list', () async {
    final fakeConvos = [
      ConversationEntity(
        id: 'c1',
        lastMessage: testMessage,
        unseenCount: 2,
        otherParticipant: testUser,
      ),
    ];

    when(mockGetConversationsUseCase.call()).thenAnswer((_) async => fakeConvos);

    await provider.fetchConversations();

    expect(provider.conversations.length, 1);
    expect(provider.conversations.first.id, 'c1');
    verify(mockGetConversationsUseCase.call()).called(1);
  });

  test('markConversationAsRead sets unseenCount to 0', () {
    provider.conversations = [
      ConversationEntity(
        id: 'c1',
        lastMessage: testMessage,
        unseenCount: 3,
        otherParticipant: testUser,
      ),
    ];

    provider.markConversationAsRead('c1');

    expect(provider.conversations.first.unseenCount, 0);
  });

  test('markConversationAsUnread sets unseenCount to 1', () {
    provider.conversations = [
      ConversationEntity(
        id: 'c2',
        lastMessage: testMessage,
        unseenCount: 0,
        otherParticipant: testUser,
      ),
    ];

    provider.markConversationAsUnread('c2');

    expect(provider.conversations.first.unseenCount, 1);
  });

  test('getConversationById returns the correct conversation', () {
    provider.conversations = [
      ConversationEntity(
        id: 'c123',
        lastMessage: testMessage,
        unseenCount: 0,
        otherParticipant: testUser,
      ),
    ];

    final convo = provider.getConversationById('c123');
    expect(convo!.id, 'c123');
  });

test('getConversationById returns null if conversation not found', () {
  provider.conversations = [];

  final convo = provider.getConversationById('unknown');
  expect(convo, isNull); // ✅ Expect null, not an exception
});

}
