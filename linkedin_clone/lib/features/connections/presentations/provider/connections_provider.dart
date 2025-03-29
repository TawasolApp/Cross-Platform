// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_connections_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/entities/connections_list_user_entity.dart';

class ConnectionsProvider with ChangeNotifier {
  ConnectionsProvider(this.getConnectionsUseCase, this.removeConnectionUseCase);

  ///Token
  ///
  String? _token;

  void setToken(String newToken) {
    _token = newToken;
  }

  ////Get connections usecase
  ///
  final GetConnectionsUseCase getConnectionsUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  List<ConnectionsListUserEntity>? connectionsList;

  Future<void> getConnections() async {
    connectionsList = await getConnectionsUseCase.call(_token);
    print("gowa el provider");
    for (var connection in connectionsList!) {
      print('Connections list: ${connection.userName}');
    }
    sortList(_activeFilter);
    print(
      "Notifying listeners length of list is ${connectionsList?.length}",
    ); // Debug check

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
    if (_activeFilter != filter) {
      sortList(filter);
      notifyListeners();
    }
  }

  void sortList(String filter) {
    if (_activeFilter != _selectedFilter) {
      _activeFilter = _selectedFilter;
    }
    if (_activeFilter == 'Recently added') {
      connectionsList!.sort(
        (a, b) => DateTime.parse(
          b.connectionTime,
        ).compareTo(DateTime.parse(a.connectionTime)),
      );
    } else if (_activeFilter == 'Last name') {
      connectionsList!.sort(
        (a, b) => a.userName.compareTo(b.userName),
      ); //TODO: Implement sorting by last name lma el backend y3ml el API doc sah
    } else if (_activeFilter == 'First name') {
      print('Sorting by first name');
      connectionsList!.sort((a, b) => a.userName.compareTo(b.userName));
    }
  }

  /////////////////////////////////////////////////
  ///
  ////Remove connection
  Future<bool> removeConnection(String userId) async {
    bool removed = await removeConnectionUseCase.call(userId, _token);
    await getConnections();
    return removed;
  }
}
