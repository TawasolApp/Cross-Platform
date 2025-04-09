// ignore_for_file: avoid_print, prefer_final_fields, curly_braces_in_flow_control_structures

import 'package:flutter/foundation.dart';
import '../../domain/entities/connections_user_entity.dart';
import '../../domain/usecases/get_connections_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/usecases/get_received_connection_requests_usecase.dart';
import '../../domain/usecases/get_sent_connection_requests_usecase.dart';
import '../../domain/usecases/accept_ignore_connection_request_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/withdraw_connection_request_usecase.dart';

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
  final AcceptIgnoreConnectionRequestUseCase
  acceptIgnoreConnectionRequestUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  final WithdrawConnectionRequestUseCase withdrawConnectionRequestUsecase;

  // Constructor
  ConnectionsProvider(
    this.getConnectionsUseCase,
    this.removeConnectionUseCase,
    this.getReceivedConnectionRequestsUseCase,
    this.getSentConnectionRequestsUseCase,
    this.acceptIgnoreConnectionRequestUseCase,
    this.sendConnectionRequestUseCase,
    this.withdrawConnectionRequestUsecase,
  );

  // Get connections
  Future<void> getConnections({bool isInitial = false}) async {
    if (_isBusy) return;
    int sortBy = 1;
    if (_activeFilter == 'First name') {
      sortBy = 2;
    } else if (_activeFilter == 'Last name') {
      sortBy = 3;
    }
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
          sortBy: sortBy,
        );
      } else {
        final newConnectionsList = await getConnectionsUseCase.call(
          page: _currentPageMain,
          limit: 15,
          sortBy: sortBy,
        );
        if (newConnectionsList.isEmpty) {
          _hasMoreMain = false;
        } else {
          connectionsList!.addAll(newConnectionsList);
        }
      }
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
    } catch (e) {
      print('\nConnectionsProvider: _getSentConnectionRequests $e\n');
      _errorSecondary = e.toString();
    }
  }

  Future<void> getSentConnectionRequests({bool isInitial = false}) async {
    print('getSentConnectionRequests called');
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _errorSecondary = null;
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

  void setActiveFilter() {
    if (_activeFilter != _selectedFilter) {
      _activeFilter = _selectedFilter;
    }
    getConnections(isInitial: true);
  }

  // Actions with bool returns
  Future<bool> removeConnection(String userId) async {
    final removed = await removeConnectionUseCase.call(userId);
    if (removed) await getConnections(isInitial: true);
    return removed;
  }

  Future<bool> acceptConnectionRequest(String userId) async {
    final accepted = await acceptIgnoreConnectionRequestUseCase.call(
      userId,
      true,
    );
    if (accepted) await getReceivedConnectionRequests(isInitial: true);
    return accepted;
  }

  Future<bool> ignoreConnectionRequest(String userId) async {
    final ignored = await acceptIgnoreConnectionRequestUseCase.call(
      userId,
      false,
    );
    if (ignored) await getReceivedConnectionRequests(isInitial: true);
    return ignored;
  }

  Future<bool> sendConnectionRequest(String userId) async {
    final sent = await sendConnectionRequestUseCase.call(userId);
    print("🤍🤍🤍🤍🤍🤍sent: $sent");
    return sent;
  }

  Future<bool> withdrawConnectionRequest(String userId) async {
    final withdrawn = await withdrawConnectionRequestUsecase.call(userId);
    if (withdrawn) await getSentConnectionRequests(isInitial: true);
    return withdrawn;
  }
}
