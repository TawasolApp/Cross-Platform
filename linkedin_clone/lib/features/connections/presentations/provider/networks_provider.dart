import 'package:flutter/foundation.dart';

class NetworksProvider with ChangeNotifier {
  List<String> _connections = [];

  List<String> get connections => _connections;

  void addConnection(String connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void removeConnection(String connection) {
    _connections.remove(connection);
    notifyListeners();
  }

  void clearConnections() {
    _connections.clear();
    notifyListeners();
  }
}
