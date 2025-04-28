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

class NotificationsProvider extends ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final GetUnseenNotificationsCountUseCase _getUnseenNotificationsCountUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final InitializeFcmUseCase _initializeFcmUseCase;

  NotificationsProvider({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required GetUnseenNotificationsCountUseCase
    getUnseenNotificationsCountUseCase,
    required GetFcmTokenUseCase getFcmTokenUseCase,
    required InitializeFcmUseCase initializeFcmUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _getUnseenNotificationsCountUseCase = getUnseenNotificationsCountUseCase,
       _getFcmTokenUseCase = getFcmTokenUseCase,
       _initializeFcmUseCase = initializeFcmUseCase;

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

  Future<void> initialize() async {
    await initializeFcm();
    await getNotifications();
    await getUnseenNotificationsCount();
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

  Future<void> getNotifications() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    final result = await _getNotificationsUseCase(NoParams());

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

  Future<void> getUnseenNotificationsCount() async {
    final result = await _getUnseenNotificationsCountUseCase(NoParams());

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

  Future<void> markNotificationAsRead(String notificationId) async {
    final result = await _markNotificationAsReadUseCase(notificationId);

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

  void resetErrors() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }
}
