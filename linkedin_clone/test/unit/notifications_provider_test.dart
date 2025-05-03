import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unseen_notifications_count_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/initialize_fcm_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/subscribe_to_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notifications_provider_test.mocks.dart';

@GenerateMocks([
  GetNotificationsUseCase,
  MarkNotificationAsReadUseCase,
  GetUnseenNotificationsCountUseCase,
  GetUnreadNotificationsUseCase,
  GetFcmTokenUseCase,
  InitializeFcmUseCase,
  SubscribeToNotificationsUseCase,
  TokenService,
])
void main() {
  late NotificationsProvider provider;
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkNotificationAsReadUseCase mockMarkNotificationAsReadUseCase;
  late MockGetUnseenNotificationsCountUseCase mockGetUnseenNotificationsCountUseCase;
  late MockGetUnreadNotificationsUseCase mockGetUnreadNotificationsUseCase;
  late MockGetFcmTokenUseCase mockGetFcmTokenUseCase;
  late MockInitializeFcmUseCase mockInitializeFcmUseCase;
  late MockSubscribeToNotificationsUseCase mockSubscribeToNotificationsUseCase;
  late MockTokenService mockTokenService;

  const testUserId = 'test-user-id';
  final testNotification = Notifications(
    notificationId: '1',
    userName: 'Test User',
    profilePicture: '',
    referenceId: 'ref-1',
    rootItemId: 'root-1',
    senderType: 'User',
    type: 'React',
    content: 'liked your post',
    isRead: false,
    timestamp: DateTime.now(),
  );

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkNotificationAsReadUseCase = MockMarkNotificationAsReadUseCase();
    mockGetUnseenNotificationsCountUseCase = MockGetUnseenNotificationsCountUseCase();
    mockGetUnreadNotificationsUseCase = MockGetUnreadNotificationsUseCase();
    mockGetFcmTokenUseCase = MockGetFcmTokenUseCase();
    mockInitializeFcmUseCase = MockInitializeFcmUseCase();
    mockSubscribeToNotificationsUseCase = MockSubscribeToNotificationsUseCase();
    mockTokenService = MockTokenService();

    provider = NotificationsProvider(
      getNotificationsUseCase: mockGetNotificationsUseCase,
      markNotificationAsReadUseCase: mockMarkNotificationAsReadUseCase,
      getUnseenNotificationsCountUseCase: mockGetUnseenNotificationsCountUseCase,
      getUnreadNotificationsUseCase: mockGetUnreadNotificationsUseCase,
      getFcmTokenUseCase: mockGetFcmTokenUseCase,
      initializeFcmUseCase: mockInitializeFcmUseCase,
      subscribeToNotificationsUseCase: mockSubscribeToNotificationsUseCase,
    );

    // Mock TokenService responses
    when(mockTokenService.getIsCompany()).thenAnswer((_) async => false);
    when(mockTokenService.getUserId()).thenAnswer((_) async => testUserId);
  });

  group('initialize', () {
    test('should load notifications successfully', () async {
      // Arrange
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Right([testNotification]));
      when(mockGetUnreadNotificationsUseCase(any))
          .thenAnswer((_) async => Right([testNotification]));
      when(mockGetUnseenNotificationsCountUseCase(any))
          .thenAnswer((_) async => const Right(1));

      // Act
      await provider.initialize();

      // Assert
      expect(provider.notifications, [testNotification]);
      expect(provider.unreadNotifications, [testNotification]);
      expect(provider.unseenNotificationsCount, 1);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
    });

    test('should handle errors when loading notifications fails', () async {
      // Arrange
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed to load')));
      when(mockGetUnreadNotificationsUseCase(any))
          .thenAnswer((_) async => Right([]));
      when(mockGetUnseenNotificationsCountUseCase(any))
          .thenAnswer((_) async => const Right(0));

      // Act
      await provider.initialize();

      // Assert
      expect(provider.notifications, isEmpty);
      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Failed to load');
      expect(provider.isLoading, false);
    });
  });

  group('getNotifications', () {
    test('should load first page of notifications', () async {
      // Arrange
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Right([testNotification]));

      // Act
      await provider.getNotifications(testUserId);

      // Assert
      expect(provider.notifications, [testNotification]);
      expect(provider.currentPage, 1);
      expect(provider.hasMore, true);
      expect(provider.isLoading, false);
      verify(mockGetNotificationsUseCase(any)).called(1);
    });

    test('should load more notifications when loadMore is true', () async {
      // Arrange
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Right([testNotification]));

      // Act - First load
      await provider.getNotifications(testUserId);
      // Act - Load more
      await provider.getNotifications(testUserId, loadMore: true);

      // Assert
      expect(provider.notifications, hasLength(2));
      expect(provider.currentPage, 2);
      expect(provider.isLoadingMore, false);
    });

    test('should not load more if already loading or no more items', () async {
      // Arrange
      provider._hasMore = false;
      provider._isLoadingMore = true;

      // Act
      await provider.getNotifications(testUserId, loadMore: true);

      // Assert
      verifyNever(mockGetNotificationsUseCase(any));
    });
  });

  group('markNotificationAsRead', () {
    test('should mark notification as read', () async {
      // Arrange
      provider._notifications = [testNotification];
      when(mockMarkNotificationAsReadUseCase(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      await provider.markNotificationAsRead(testUserId, testNotification.notificationId);

      // Assert
      expect(provider.notifications.first.isRead, true);
      expect(provider.unseenNotificationsCount, 0);
      verify(mockMarkNotificationAsReadUseCase(any)).called(1);
    });

    test('should handle error when marking as read fails', () async {
      // Arrange
      provider._notifications = [testNotification];
      when(mockMarkNotificationAsReadUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      // Act
      await provider.markNotificationAsRead(testUserId, testNotification.notificationId);

      // Assert
      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Failed');
      expect(provider.notifications.first.isRead, false); // Should remain unread
    });
  });

  group('FCM operations', () {
    test('initializeFcm should get token on success', () async {
      // Arrange
      when(mockInitializeFcmUseCase(any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetFcmTokenUseCase(any))
          .thenAnswer((_) async => const Right('test-token'));

      // Act
      await provider.initializeFcm();

      // Assert
      expect(provider.fcmToken, 'test-token');
      expect(provider.isLoading, false);
    });

    test('getFcmToken should update token', () async {
      // Arrange
      when(mockGetFcmTokenUseCase(any))
          .thenAnswer((_) async => const Right('test-token'));

      // Act
      await provider.getFcmToken();

      // Assert
      expect(provider.fcmToken, 'test-token');
    });
  });

  group('pagination', () {
    test('should reset pagination when loading first page', () async {
      // Arrange
      provider._currentPage = 2;
      provider._hasMore = false;
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Right([testNotification]));

      // Act
      await provider.getNotifications(testUserId);

      // Assert
      expect(provider.currentPage, 1);
      expect(provider.hasMore, true);
    });

    test('should decrement page on loadMore failure', () async {
      // Arrange
      provider._currentPage = 1;
      when(mockGetNotificationsUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      // Act
      await provider.getNotifications(testUserId, loadMore: true);

      // Assert
      expect(provider.currentPage, 1); // Should revert from 2 to 1
    });
  });

  group('error handling', () {
    test('resetErrors should clear error state', () {
      // Arrange
      provider._hasError = true;
      provider._errorMessage = 'Test error';

      // Act
      provider.resetErrors();

      // Assert
      expect(provider.hasError, false);
      expect(provider.errorMessage, '');
    });
  });

  group('markAllNotificationsAsSeen', () {
    test('should reset unseen notifications count', () {
      // Arrange
      provider._unseenNotificationsCount = 5;

      // Act
      provider.markAllNotificationsAsSeen(testUserId);

      // Assert
      expect(provider.unseenNotificationsCount, 0);
    });
  });
}