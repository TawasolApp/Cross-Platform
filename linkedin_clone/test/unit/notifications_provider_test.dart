import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';

import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unseen_notifications_count_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/initialize_fcm_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/subscribe_to_notifications_usecase.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkNotificationAsReadUseCase extends Mock
    implements MarkNotificationAsReadUseCase {}

class MockGetUnseenNotificationsCountUseCase extends Mock
    implements GetUnseenNotificationsCountUseCase {}

class MockGetUnreadNotificationsUseCase extends Mock
    implements GetUnreadNotificationsUseCase {}

class MockGetFcmTokenUseCase extends Mock implements GetFcmTokenUseCase {}

class MockInitializeFcmUseCase extends Mock implements InitializeFcmUseCase {}

class MockSubscribeToNotificationsUseCase extends Mock
    implements SubscribeToNotificationsUseCase {}

/// 👇 Add this Fake class
class FakeGetNotificationsParams extends Fake
    implements GetNotificationsParams {}

void main() {
  late NotificationsProvider provider;
  late MockGetNotificationsUseCase mockGetNotifications;
  late MockMarkNotificationAsReadUseCase mockMarkAsRead;
  late MockGetUnseenNotificationsCountUseCase mockGetUnseenCount;
  late MockGetUnreadNotificationsUseCase mockGetUnread;
  late MockGetFcmTokenUseCase mockGetFcm;
  late MockInitializeFcmUseCase mockInitFcm;
  late MockSubscribeToNotificationsUseCase mockSubscribe;

  /// 👇 Register fallback once globally
  setUpAll(() {
    registerFallbackValue(FakeGetNotificationsParams());
  });

  setUp(() {
    mockGetNotifications = MockGetNotificationsUseCase();
    mockMarkAsRead = MockMarkNotificationAsReadUseCase();
    mockGetUnseenCount = MockGetUnseenNotificationsCountUseCase();
    mockGetUnread = MockGetUnreadNotificationsUseCase();
    mockGetFcm = MockGetFcmTokenUseCase();
    mockInitFcm = MockInitializeFcmUseCase();
    mockSubscribe = MockSubscribeToNotificationsUseCase();

    provider = NotificationsProvider(
      getNotificationsUseCase: mockGetNotifications,
      markNotificationAsReadUseCase: mockMarkAsRead,
      getUnseenNotificationsCountUseCase: mockGetUnseenCount,
      getUnreadNotificationsUseCase: mockGetUnread,
      getFcmTokenUseCase: mockGetFcm,
      initializeFcmUseCase: mockInitFcm,
      subscribeToNotificationsUseCase: mockSubscribe,
    );
  });

  group('getNotifications', () {
    final notifications = [
      Notifications(
        notificationId: '1',
        userName: 'Aya',
        profilePicture: '',
        referenceId: '',
        rootItemId: '',
        senderType: '',
        type: '',
        content: 'New message',
        isRead: false,
        timestamp: DateTime.now(),
      ),
    ];

    test('should fetch and assign notifications successfully', () async {
      when(
        () => mockGetNotifications(any()),
      ).thenAnswer((_) async => Right(notifications));

      await provider.getNotifications('testId');

      expect(provider.notifications, notifications);
      expect(provider.hasError, false);
    });

    test('should handle failure and set error', () async {
      when(
        () => mockGetNotifications(any()),
      ).thenAnswer((_) async => Left(ServerFailure('Something went wrong')));

      await provider.getNotifications('testId');

      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Something went wrong');
    });
  });
}
