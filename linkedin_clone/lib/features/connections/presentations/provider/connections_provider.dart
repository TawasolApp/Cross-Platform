// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../../domain/entities/connections_user_entity.dart';
import '../../domain/usecases/get_connections_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/usecases/get_received_connection_requests_usecase.dart';
import '../../domain/usecases/get_sent_connection_requests_usecase.dart';
import '../../domain/usecases/accept_connection_request_usecase.dart';
import '../../domain/usecases/ignore_connection_request_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';

class ConnectionsProvider with ChangeNotifier {
  // Variables
  List<ConnectionsUserEntity>? connectionsList;
  List<ConnectionsUserEntity>? receivedConnectionRequestsList;
  List<ConnectionsUserEntity>? sentConnectionRequestsList;

  String? _error;
  bool _isloading = false;
  int _currentPage = 1;
  // ignore: prefer_final_fields
  bool _isBusy = false;
  bool _hasMore = true;
  String _activeFilter = 'Recently added';
  String _selectedFilter = 'Recently added';

  // Getters
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isLoading => _isloading;
  bool get isBusy => _isBusy;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String get selectedFilter => _selectedFilter;
  String get activeFilter => _activeFilter;

  // UseCases
  final GetConnectionsUseCase getConnectionsUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  final GetReceivedConnectionRequestsUseCase
  getReceivedConnectionRequestsUseCase;
  final GetSentConnectionRequestsUseCase getSentConnectionRequestsUseCase;
  final AcceptConnectionRequestUseCase acceptConnectionRequestUseCase;
  final IgnoreConnectionRequestUseCase ignoreConnectionRequestUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;

  // Constructor
  ConnectionsProvider(
    this.getConnectionsUseCase,
    this.removeConnectionUseCase,
    this.getReceivedConnectionRequestsUseCase,
    this.getSentConnectionRequestsUseCase,
    this.acceptConnectionRequestUseCase,
    this.ignoreConnectionRequestUseCase,
    this.sendConnectionRequestUseCase,
  );

  // Get connections
  Future<void> getConnections({bool isInitial = false}) async {
    if (_isBusy) return;
    try {
      _isloading = true;
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      //notifyListeners();
      if (currentPage == 1) {
        connectionsList = await getConnectionsUseCase.call(
          page: _currentPage,
          limit: 15,
        );
      } else {
        final newConnectionsList = await getConnectionsUseCase.call(
          page: _currentPage,
          limit: 15,
        );
        if (newConnectionsList.isEmpty) {
          _hasMore = false;
        } else {
          connectionsList!.addAll(newConnectionsList);
        }
      }
      sortList(_activeFilter, connectionsList);
    } catch (e) {
      print('\nConnectionsProvider: getConnections $e\n');
      _error = e.toString();
    } finally {
      _isloading = false;
      _isBusy = false;

      notifyListeners();
    }
  }

  // Get received connection requests
  Future<void> getReceivedConnectionRequests() async {
    try {
      _isloading = true;
      _error = null;

      receivedConnectionRequestsList =
          await getReceivedConnectionRequestsUseCase.call("");

      receivedConnectionRequestsList = sortList(
        "Recently added",
        receivedConnectionRequestsList,
      );
    } catch (e) {
      print('\nConnectionsProvider: getReceivedConnectionRequests $e\n');
      _error = e.toString();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  // Get sent connection requests
  Future<void> getSentConnectionRequests() async {
    try {
      print("Fetching sent connection requests...");
      _isloading = true;
      _error = null;

      sentConnectionRequestsList = await getSentConnectionRequestsUseCase.call(
        "",
      );

      sentConnectionRequestsList = sortList(
        "Recently added",
        sentConnectionRequestsList,
      );
    } catch (e) {
      print('\nConnectionsProvider: sentConnectionRequestsList $e\n');
      _error = e.toString();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  // Sort handling
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
      list!.sort((a, b) => a.lastName.compareTo(b.lastName));
    } else if (_activeFilter == 'First name') {
      list!.sort((a, b) => a.firstName.compareTo(b.firstName));
    }

    return list;
  }

  // Actions with bool returns
  Future<bool> removeConnection(String userId) async {
    final removed = await removeConnectionUseCase.call(userId, "_token");
    await getConnections();
    return removed;
  }

  Future<bool> acceptConnectionRequest(String userId) async {
    final accepted = await acceptConnectionRequestUseCase.call("", userId);
    if (accepted) await getReceivedConnectionRequests();
    return accepted;
  }

  Future<bool> ignoreConnectionRequest(String userId) async {
    final ignored = await ignoreConnectionRequestUseCase.call('', userId);
    if (ignored) await getReceivedConnectionRequests();
    return ignored;
  }

  Future<bool> sendConnectionRequest(String userId) async {
    final sent = await sendConnectionRequestUseCase.call("", userId);
    if (sent) await getReceivedConnectionRequests();
    return sent;
  }
}
