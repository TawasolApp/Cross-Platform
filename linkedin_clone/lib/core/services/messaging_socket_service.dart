import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagingSocketService {
  static final MessagingSocketService _instance = MessagingSocketService._internal();
  factory MessagingSocketService() => _instance;

  late IO.Socket socket;

  MessagingSocketService._internal();


  void connect(String userId) {
    socket = IO.io('https://tawasolapp.me', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to Socket.IO');
      print('🔑 Registering user: $userId');
      socket.emit('register', userId);
    });

    socket.onConnectError((data) => print('❌ Socket connection error: $data'));
    socket.onDisconnect((_) => print('🔌 Socket disconnected'));
  }

  void listenToMessages(Function(dynamic) onMessage) {
    socket.on('receive_message', (data) {
      print('📥 Received message: $data');
      onMessage(data);
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('send_message', message);
  }

  void sendTyping(dynamic payload) {
    socket.emit('typing', payload);
  }

  void markMessagesRead(String conversationId) {
    socket.emit('messages_read', {'conversationId': conversationId});
  }

  void markAllDelivered() {
    socket.emit('messages_delivered');
  }

  void disconnect() {
    socket.disconnect();
  }
}
