import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unseen_notifications_count_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/initialize_fcm_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/subscribe_to_notifications_usecase.dart';

class NotificationsProvider extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final GetUnseenNotificationsCountUseCase _getUnseenNotificationsCountUseCase;
  final GetUnreadNotificationsUseCase _getUnreadNotificationsUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final InitializeFcmUseCase _initializeFcmUseCase;
  final SubscribeToNotificationsUseCase _subscribeToNotificationsUseCase;

  NotificationsProvider({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required GetUnseenNotificationsCountUseCase
    getUnseenNotificationsCountUseCase,
    required GetUnreadNotificationsUseCase getUnreadNotificationsUseCase,
    required GetFcmTokenUseCase getFcmTokenUseCase,
    required InitializeFcmUseCase initializeFcmUseCase,
    required SubscribeToNotificationsUseCase subscribeToNotificationsUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _getUnseenNotificationsCountUseCase = getUnseenNotificationsCountUseCase,
       _getUnreadNotificationsUseCase = getUnreadNotificationsUseCase,
       _getFcmTokenUseCase = getFcmTokenUseCase,
       _initializeFcmUseCase = initializeFcmUseCase,
       _subscribeToNotificationsUseCase = subscribeToNotificationsUseCase;

  List<Notifications> _notifications = [];
  List<Notifications> _unreadNotifications = [];

  List<Notifications> get notifications => _notifications;
  List<Notifications> get unreadNotifications => _unreadNotifications;

  int _unseenNotificationsCount = 0;
  int get unseenNotificationsCount => _unseenNotificationsCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  StreamSubscription<Either<Failure, Notifications>>? _notificationSubscription;

  // Add these new pagination properties
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Add getters
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> initialize() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    String id;

    final isCompany = await TokenService.getIsCompany();
    if (isCompany == true) {
      id = (await TokenService.getCompanyId()).toString();
    } else {
      id = (await TokenService.getUserId()).toString();
    }

    try {
      await getNotifications(id);
      await getUnreadNotifications(id);
      await getUnseenNotificationsCount(id);
      // _subscribeToNotificationStream();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializeFcm() async {
    _isLoading = true;
    notifyListeners();

    final result = await _initializeFcmUseCase(NoParams());

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (_) {
        getFcmToken();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getFcmToken() async {
    final result = await _getFcmTokenUseCase(NoParams());

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (token) {
        _fcmToken = token;
      },
    );
    notifyListeners();
  }

  // Modify getNotifications method
  Future<void> getNotifications(String id, {bool loadMore = false}) async {
    if (loadMore && (!_hasMore || _isLoadingMore)) return;
    
    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _isLoading = true;
    } else {
      _currentPage++;
      _isLoadingMore = true;
    }
    
    notifyListeners();

    final result = await _getNotificationsUseCase(
      GetNotificationsParams(
        id: id, 
        page: _currentPage, 
        limit: _itemsPerPage,
      ),
    );

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
        if (loadMore) _currentPage--; // Revert page increment on failure
      },
      (newNotifications) {
        // Sort by timestamp (newest first)
        newNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        
        if (loadMore) {
          _notifications.addAll(newNotifications);
        } else {
          _notifications = newNotifications;
        }
        
        // Check if we've reached the end
        _hasMore = newNotifications.length >= _itemsPerPage;
      },
    );

    if (loadMore) {
      _isLoadingMore = false;
    } else {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getUnseenNotificationsCount(String id) async {
    final result = await _getUnseenNotificationsCountUseCase(id);

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (count) {
        _unseenNotificationsCount = count;
      },
    );
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String id, String notificationId) async {
    final result = await _markNotificationAsReadUseCase(
      MarkNotificationAsReadParams(id: id, notificationId: notificationId),
    );

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        final notification = _notifications.firstWhere(
          (n) => n.notificationId == notificationId,
          orElse: () => _notifications.first,
        );

        final index = _notifications.indexOf(notification);
        if (index != -1) {
          final updatedNotification = Notifications(
            notificationId: notification.notificationId,
            userName: notification.userName,
            profilePicture: notification.profilePicture,
            referenceId: notification.referenceId,
            rootItemId: notification.rootItemId,
            senderType: notification.senderType,
            type: notification.type,
            content: notification.content,
            isRead: true,
            timestamp: notification.timestamp,
          );

          _notifications[index] = updatedNotification;
          _unseenNotificationsCount =
              _unseenNotificationsCount > 0 ? _unseenNotificationsCount - 1 : 0;
          notifyListeners();
        }
      },
    );
  }

  Future<void> getUnreadNotifications(String id, {int page = 1, int limit = 10}) async {
    final result = await _getUnreadNotificationsUseCase(
      GetUnreadNotificationsParams(id: id, page: page, limit: limit),
    );

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (unreadNotifications) {
        if (page == 1) {
          _unreadNotifications = unreadNotifications;
        } else {
          _unreadNotifications.addAll(unreadNotifications);
        }
      },
    );
    notifyListeners();
  }

  // Add a new method to subscribe to company notifications on the server
  Future<void> subscribeToNotifications(String id) async {
    final result = await _subscribeToNotificationsUseCase(id);

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (_) {
        // Successfully subscribed to notifications on the server
      },
    );
  }

  // Renamed from _subscribeToNotifications to better reflect its purpose
  // void _subscribeToNotificationStream() {
  //   // Cancel existing subscription if any
  //   _notificationSubscription?.cancel();

  //   // Set up new subscription to the notification stream
  //   _notificationSubscription = _subscribeToNotificationsUseCase.stream.listen(
  //     (notificationResult) {
  //       notificationResult.fold(
  //         (failure) {
  //           _hasError = true;
  //           _errorMessage = failure.message;
  //         },
  //         (notification) {
  //           _notifications.insert(0, notification);
  //           _unseenNotificationsCount++;
  //         },
  //       );
  //       notifyListeners();
  //     },
  //     onError: (error) {
  //       _hasError = true;
  //       _errorMessage = error.toString();
  //       notifyListeners();
  //     },
  //   );
  // }

  void resetErrors() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
