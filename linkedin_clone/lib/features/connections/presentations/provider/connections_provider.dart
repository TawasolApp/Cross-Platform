// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_connections_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/usecases/get_received_connection_requests_usecase.dart';
import '../../domain/usecases/get_sent_connection_requests_usecase.dart';
import '../../domain/entities/connections_user_entity.dart';

class ConnectionsProvider with ChangeNotifier {
  ConnectionsProvider(
    this.getConnectionsUseCase,
    this.removeConnectionUseCase,
    this.getReceivedConnectionRequestsUseCase,
    this.getSentConnectionRequestsUseCase,
  );

  List<ConnectionsUserEntity>? connectionsList;
  List<ConnectionsUserEntity>? receivedConnectionRequestsList;
  List<ConnectionsUserEntity>? sentConnectionRequestsList;
  ////Get connections usecase
  ///
  final GetConnectionsUseCase getConnectionsUseCase;

  ////Get received Connection Requests usecase
  ///

  final GetReceivedConnectionRequestsUseCase
  getReceivedConnectionRequestsUseCase;

  ////Get sent Connection Requests usecase
  ///

  final GetSentConnectionRequestsUseCase getSentConnectionRequestsUseCase;

  /////////////////////////////////////////////////
  ///
  ////Remove connection
  final RemoveConnectionUseCase removeConnectionUseCase;

  /////////////////////////////////////////////////
  ///
  ////filter
  ///
  String _activeFilter = 'Recently added';
  String _selectedFilter = 'Recently added';

  ///Token
  ///
  String? _token;

  void setToken(String newToken) {
    _token = newToken;
  }

  Future<void> getConnections() async {
    connectionsList = await getConnectionsUseCase.call(_token);
    sortList(_activeFilter, connectionsList);
    notifyListeners();
  }

  String get selectedFilter => _selectedFilter;

  String get activeFilter => _activeFilter;

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
    }
    notifyListeners();
  }

  void sortConnectionBy(String filter) {
    if (_activeFilter != filter) {
      connectionsList = sortList(filter, connectionsList);
      notifyListeners();
    }
  }

  List<ConnectionsUserEntity>? sortList(
    String filter,
    List<ConnectionsUserEntity>? list,
  ) {
    if (_activeFilter != _selectedFilter) {
      _activeFilter = _selectedFilter;
    }
    if (_activeFilter == 'Recently added') {
      list!.sort(
        (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)),
      );
    } else if (_activeFilter == 'Last name') {
      list!.sort(
        (a, b) => a.userName.compareTo(b.userName),
      ); //TODO: Implement sorting by last name lma el backend y3ml el API doc sah
    } else if (_activeFilter == 'First name') {
      print('Sorting by first name');
      list!.sort((a, b) => a.userName.compareTo(b.userName));
    }
    return list;
  }

  Future<bool> removeConnection(String userId) async {
    bool removed = await removeConnectionUseCase.call(userId, _token);
    await getConnections();
    return removed;
  }

  Future<void> getReceivedConnectionRequests() async {
    receivedConnectionRequestsList = await getReceivedConnectionRequestsUseCase
        .call(_token);
    print(receivedConnectionRequestsList);
    receivedConnectionRequestsList = sortList(
      "Recently added",
      receivedConnectionRequestsList,
    );
    notifyListeners();
  }

  Future<void> getSentConnectionRequests() async {
    receivedConnectionRequestsList = await getReceivedConnectionRequestsUseCase
        .call(_token);
    print(receivedConnectionRequestsList);
    receivedConnectionRequestsList = sortList(
      "Recently added",
      receivedConnectionRequestsList,
    );
    notifyListeners();
  }
}
