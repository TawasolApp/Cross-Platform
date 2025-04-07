// ignore_for_file: avoid_print, prefer_final_fields, curly_braces_in_flow_control_structures

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

  String? _errorMain, _errorSecondary;
  bool _isLoading = false;
  int _currentPageMain = 1;
  int _currentPageSecondary = 1;
  bool _isBusy = false;
  bool _hasMoreMain = true;
  bool _hasMoreSecondary = true;
  String _activeFilter = 'Recently added';
  String _selectedFilter = 'Recently added';

  // Getters
  String? get errorMain => _errorMain;
  bool get hasErrorMain => _errorMain != null;
  bool get hasErrorSecondary => _errorSecondary != null;
  String? get errorSecondary => _errorSecondary;
  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  bool get hasMoreMain => _hasMoreMain;
  bool get hasMoreSecondary => _hasMoreSecondary;
  int get currentPageMain => _currentPageMain;
  int get currentPageSecondary => _currentPageSecondary;
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
    _isBusy = true;
    try {
      _isLoading = true;
      _errorMain = null;
      if (isInitial) {
        _currentPageMain = 1;
        _hasMoreMain = true;
      } else {
        _currentPageMain++;
      }
      if (_currentPageMain == 1) {
        connectionsList = await getConnectionsUseCase.call(
          page: _currentPageMain,
          limit: 15,
        );
      } else {
        final newConnectionsList = await getConnectionsUseCase.call(
          page: _currentPageMain,
          limit: 15,
        );
        if (newConnectionsList.isEmpty) {
          _hasMoreMain = false;
        } else {
          connectionsList!.addAll(newConnectionsList);
        }
      }
      sortList(_activeFilter, connectionsList);
    } catch (e) {
      print('\nConnectionsProvider: getConnections $e\n');
      _errorMain = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;

      notifyListeners();
    }
  }

  // Get received connection requests
  Future<void> _getReceivedConnectionRequests({bool isInitial = false}) async {
    print("\nConnectionsProvider: _getReceivedConnectionRequests\n");
    try {
      if (isInitial) {
        _currentPageMain = 1;
        _hasMoreMain = true;
      } else {
        _currentPageMain++;
      }

      if (_currentPageMain == 1) {
        receivedConnectionRequestsList =
            await getReceivedConnectionRequestsUseCase.call(
              page: _currentPageMain,
              limit: 15,
            );
      } else {
        final newReceivedConnectionsList =
            await getReceivedConnectionRequestsUseCase.call(
              page: _currentPageMain,
              limit: 15,
            );
        if (newReceivedConnectionsList.isEmpty) {
          _hasMoreMain = false;
        } else {
          receivedConnectionRequestsList!.addAll(newReceivedConnectionsList);
        }
      }
      receivedConnectionRequestsList = sortList(
        "Recently added",
        receivedConnectionRequestsList,
      );
    } catch (e) {
      print('\nConnectionsProvider: _getReceivedConnectionRequests $e\n');
      _errorMain = e.toString();
    }
  }

  Future<void> getReceivedConnectionRequests({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _errorMain = null;
      notifyListeners();

      await _getReceivedConnectionRequests(isInitial: isInitial);
    } catch (e) {
      print('\nConnectionsProvider: getReceivedConnectionRequests $e\n');
      _errorMain = e.toString();
    } finally {
      _isBusy = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get sent connection requests
  Future<void> _getSentConnectionRequests({bool isInitial = false}) async {
    try {
      if (isInitial) {
        _currentPageSecondary = 1;
        _hasMoreSecondary = true;
      } else {
        _currentPageSecondary++;
      }

      if (_currentPageSecondary == 1) {
        sentConnectionRequestsList = await getSentConnectionRequestsUseCase
            .call(page: _currentPageSecondary, limit: 15);
      } else {
        final newSentConnectionsList = await getSentConnectionRequestsUseCase
            .call(page: _currentPageSecondary, limit: 15);
        if (newSentConnectionsList.isEmpty) {
          _hasMoreSecondary = false;
        } else {
          sentConnectionRequestsList!.addAll(newSentConnectionsList);
        }
      }
      sentConnectionRequestsList = sortList(
        "Recently added",
        sentConnectionRequestsList,
      );
    } catch (e) {
      print('\nConnectionsProvider: _getSentConnectionRequests $e\n');
      _errorSecondary = e.toString();
    }
  }

  Future<void> getSentConnectionRequests({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _errorSecondary = null;
      notifyListeners();
      await _getSentConnectionRequests(isInitial: isInitial);
    } catch (e) {
      print('\nConnectionsProvider: getSentConnectionRequests $e\n');
      _errorMain = e.toString();
    } finally {
      _isBusy = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getInvitations({
    bool isInitsent = false,
    bool isInitRec = false,
    bool refreshSent = false,
    bool refreshRec = false,
  }) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _errorMain = null;
      _errorSecondary = null;
      if (refreshSent) await _getSentConnectionRequests(isInitial: isInitsent);
      if (refreshRec)
        await _getReceivedConnectionRequests(isInitial: isInitRec);
    } catch (e) {
      print('\nConnectionsProvider: getInvitationDetails $e\n');
      _errorMain = e.toString();
    } finally {
      _isBusy = false;
      _isLoading = false;
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
