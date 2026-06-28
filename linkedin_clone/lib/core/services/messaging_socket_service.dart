import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagingSocketService {
  static final MessagingSocketService _instance = MessagingSocketService._internal();
  factory MessagingSocketService() => _instance;

  late IO.Socket socket;

  MessagingSocketService._internal();


  void connect(String userId) {
  socket = IO.io(
    'wss://tawasolapp.me',
    <String, dynamic>{
      'transports': ['websocket'],
      'upgrade': false, // Important for compatibility
      'query': {'userId': userId}, // ✅ MATCH frontend
      'withCredentials': true,     // ✅ MATCH frontend
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
    },
  );

  socket.connect();

  socket.onConnect((_) {
    print('✅ Connected to Socket.IO');
    print('🔑 Registering user: $userId');
    socket.emit('register', userId); // Optional if query is enough
  });

  socket.onDisconnect((reason) {
    print('🔌 Socket disconnected: $reason'); // ADD THIS
  });

  socket.onConnectError((err) {
    print('❌ Socket connection error: $err'); // ADD THIS
  });

  socket.onError((err) {
    print('❗ General socket error: $err'); // ADD THIS
  });
}


  void listenToMessages(Function(dynamic) onMessage) {
    socket.on('receive_message', (data) {
      print('📥 Received message: $data');
      onMessage(data);
    });
  }

    void listenToTyping(Function(dynamic) onTyping) {
    socket.on('typing', (data) {
      print('✏️ Typing received: $data');
      onTyping(data);
    });
  }


 void sendMessage(Map<String, dynamic> message) {
  socket.emitWithAck('send_message', message, ack: (data) {
    print('🟢 Message ACK: $data');

    if (data is Map && data['success'] != true) {
      print('❌ Message send failed');
    }
  });
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
