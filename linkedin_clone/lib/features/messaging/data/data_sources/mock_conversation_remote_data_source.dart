import 'package:linkedin_clone/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/data/models/conversation_model.dart';

class MockConversationRemoteDataSource implements ConversationRemoteDataSource {
  Future<List<ConversationModel>> fetchConversations() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      ConversationModel(
        id: 'conv1',
        lastMessageText: 'Hey, how are you?',
        lastMessageTime: '3:30 AM',
        otherParticipantName: 'Nour Nader',
        otherParticipantProfilePic: 'https://randomuser.me/api/portraits/women/1.jpg',
        unseenCount: 2,
      ),
      ConversationModel(
        id: 'conv2',
        lastMessageText: 'Let\'s catch up over coffee!',
        lastMessageTime: 'Wednesday',
        otherParticipantName: 'Jana M.',
        otherParticipantProfilePic: 'https://randomuser.me/api/portraits/women/2.jpg',
        unseenCount: 0,
      ),
      ConversationModel(
        id: 'conv3',
        lastMessageText: 'Hi there, Omar! Interested in a new job?',
        lastMessageTime: 'Apr 20',
        otherParticipantName: 'LinkedIn Offer',
        otherParticipantProfilePic: 'https://upload.wikimedia.org/wikipedia/commons/c/ca/LinkedIn_logo_initials.png',
        unseenCount: 1,
      ),
      ConversationModel(
        id: 'conv4',
        lastMessageText: 'Flexible 1K USD per week opportunity',
        lastMessageTime: 'Apr 11',
        otherParticipantName: 'Phoebe R.',
        otherParticipantProfilePic: 'https://randomuser.me/api/portraits/women/3.jpg',
        unseenCount: 0,
      ),
    ];
  }
}
