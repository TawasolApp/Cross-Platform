import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unseen_notifications_count_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/initialize_fcm_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/subscribe_to_notifications_usecase.dart';

class NotificationsProvider extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final GetUnseenNotificationsCountUseCase _getUnseenNotificationsCountUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final InitializeFcmUseCase _initializeFcmUseCase;
  final SubscribeToNotificationsUseCase _subscribeToNotificationsUseCase;

  NotificationsProvider({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required GetUnseenNotificationsCountUseCase
    getUnseenNotificationsCountUseCase,
    required GetFcmTokenUseCase getFcmTokenUseCase,
    required InitializeFcmUseCase initializeFcmUseCase,
    required SubscribeToNotificationsUseCase subscribeToNotificationsUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _getUnseenNotificationsCountUseCase = getUnseenNotificationsCountUseCase,
       _getFcmTokenUseCase = getFcmTokenUseCase,
       _initializeFcmUseCase = initializeFcmUseCase,
       _subscribeToNotificationsUseCase = subscribeToNotificationsUseCase;

  List<Notifications> _notifications = [];
  List<Notifications> get notifications => _notifications;

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

  Future<void> initialize(String companyId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await initializeFcm();
      // await getNotifications(companyId);
      // await getUnseenNotificationsCount(companyId);
      await subscribeToCompanyNotifications(companyId);
      _subscribeToNotificationStream();
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

  Future<void> getNotifications(String companyId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    final result = await _getNotificationsUseCase(companyId);

    result.fold(
      (failure) {
        _hasError = true;
        _errorMessage = failure.message;
      },
      (notificationsList) {
        _notifications = notificationsList;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUnseenNotificationsCount(String companyId) async {
    final result = await _getUnseenNotificationsCountUseCase(companyId);

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

  Future<void> markNotificationAsRead(
    String companyId,
    String notificationId,
  ) async {
    final result = await _markNotificationAsReadUseCase(
      MarkNotificationAsReadParams(
        companyId: companyId,
        notificationId: notificationId,
      ),
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

  // Add a new method to subscribe to company notifications on the server
  Future<void> subscribeToCompanyNotifications(String companyId) async {
    final result = await _subscribeToNotificationsUseCase(companyId);

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
  void _subscribeToNotificationStream() {
    // Cancel existing subscription if any
    _notificationSubscription?.cancel();

    // Set up new subscription to the notification stream
    _notificationSubscription = _subscribeToNotificationsUseCase.stream.listen(
      (notificationResult) {
        notificationResult.fold(
          (failure) {
            _hasError = true;
            _errorMessage = failure.message;
          },
          (notification) {
            _notifications.insert(0, notification);
            _unseenNotificationsCount++;
          },
        );
        notifyListeners();
      },
      onError: (error) {
        _hasError = true;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

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
