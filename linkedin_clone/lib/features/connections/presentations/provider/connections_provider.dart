import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_connections_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/entities/connections_list_user_entity.dart';

class ConnectionsProvider with ChangeNotifier {
  ConnectionsProvider(this.getConnectionsUseCase, this.removeConnectionUseCase);

  /////Token
  ///
  String? _token;

  String? get token => _token;

  void setToken(String newToken) {
    _token = newToken;
  }

  void clearToken() {
    _token = null;
    notifyListeners();
  }

  ////Get connections usecase
  final GetConnectionsUseCase getConnectionsUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  List<ConnectionsListUserEntity>? get connectionsList => _connectionsList;
  List<ConnectionsListUserEntity>? _connectionsList;

  Future<List<ConnectionsListUserEntity>> getConnections(String token) async {
    _connectionsList = await getConnectionsUseCase.call(token);
    notifyListeners();
    return _connectionsList!;
  }

  set connectionsList(List<ConnectionsListUserEntity>? connections) {
    _connectionsList = connections;
    notifyListeners();
  }

  ////////////////////////////////////////////////////
  ///
  ////search
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    notifyListeners();
  }

  /////////////////////////////////////////////////
  ///
  ////filter
  String _selectedFilter = 'Recently added';
  String get selectedFilter => _selectedFilter;
  String _activeFilter = 'Recently added';
  String get activeFilter => _activeFilter;

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
    }
    notifyListeners();
  }

  void sortConnectionBy(String filter) {
    if (_activeFilter != _selectedFilter) {
      _activeFilter = _selectedFilter;
    }
    if (_activeFilter == 'Recently added') {
      _connectionsList!.sort(
        (a, b) => DateTime.parse(
          b.connectionTime,
        ).compareTo(DateTime.parse(a.connectionTime)),
      );
    } else if (_activeFilter == 'Last name') {
      _connectionsList!.sort(
        (a, b) => a.userName.compareTo(b.userName),
      ); //TODO: Implement sorting by last name lma el backend y3ml el API doc sah
    } else if (_activeFilter == 'First name') {
      print('Sorting by first name');
      _connectionsList!.sort((a, b) => a.userName.compareTo(b.userName));
    }
    notifyListeners();
  }

  /////////////////////////////////////////////////
  ///
  ////Remove connection
  Future<bool> removeConnection(String userId) async {
    bool removed = await removeConnectionUseCase.call(userId, _token);
    notifyListeners();
    return removed;
  }
}
