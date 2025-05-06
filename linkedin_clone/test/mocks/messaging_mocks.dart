import 'package:linkedin_clone/features/messaging/domain/usecases/get_conversations_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/messaging/domain/usecases/get_chat_use_case.dart';
import 'package:linkedin_clone/core/services/messaging_socket_service.dart';

@GenerateMocks([GetChatUseCase, MessagingSocketService,GetConversationsUseCase])
void main() {}
