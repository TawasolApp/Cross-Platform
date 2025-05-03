import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/privacy/domain/entities/privacy_user_entity.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/block_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/report_post_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/report_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'privacy_provider_test.mocks.dart';

@GenerateMocks([
  BlockUserUseCase,
  UnblockUserUseCase,
  GetBlockedListUseCase,
  ReportPostUseCase,
  ReportUserUseCase,
])
void main() {
  late PrivacyProvider provider;
  late MockBlockUserUseCase mockBlockUser;
  late MockUnblockUserUseCase mockUnblockUser;
  late MockGetBlockedListUseCase mockGetBlockedList;
  late MockReportPostUseCase mockReportPost;
  late MockReportUserUseCase mockReportUser;

  final testBlockedUser = PrivacyUserEntity(
    userId: 'blocked-user-123',
    firstName: 'Blocked',
    lastName: 'User',
    profilePicture: '',
  );

  setUp(() {
    mockBlockUser = MockBlockUserUseCase();
    mockUnblockUser = MockUnblockUserUseCase();
    mockGetBlockedList = MockGetBlockedListUseCase();
    mockReportPost = MockReportPostUseCase();
    mockReportUser = MockReportUserUseCase();

    provider = PrivacyProvider(
      blockUserUseCase: mockBlockUser,
      unblockUserUseCase: mockUnblockUser,
      getBlockedListUseCase: mockGetBlockedList,
      reportPostUseCase: mockReportPost,
      reportUserUseCase: mockReportUser,
    );
  });

  test('initial values are correct', () {
    expect(provider.isLoading, false);
    expect(provider.isBusy, false);
    expect(provider.error, null);
    expect(provider.hasError, false);
    expect(provider.blockedUsers, null);
    expect(provider.reportReason, null);
    expect(provider.reportReasonSelected, false);
  });

  group('Blocked Users Management', () {
    test('getBlockedUsers loads data successfully', () async {
      when(
        mockGetBlockedList.call(),
      ).thenAnswer((_) async => [testBlockedUser]);

      await provider.getBlockedUsers();

      expect(provider.blockedUsers, isNotNull);
      expect(provider.blockedUsers!.length, 1);
      expect(provider.hasError, false);
      expect(provider.isLoading, false);
    });

    test('getBlockedUsers handles errors', () async {
      when(mockGetBlockedList.call()).thenThrow(Exception('Failed to load'));

      await provider.getBlockedUsers();

      expect(provider.hasError, true);
      expect(provider.error, isNotNull);
      expect(provider.isLoading, false);
    });

    test('getBlockedUsers does nothing when busy', () async {
      provider.isBusy = true;
      await provider.getBlockedUsers();
      verifyNever(mockGetBlockedList.call());
    });
  });

  group('User Blocking', () {
    test('blockUser returns true on success', () async {
      when(mockBlockUser.call(any)).thenAnswer((_) async => true);
      when(
        mockGetBlockedList.call(),
      ).thenAnswer((_) async => [testBlockedUser]);

      final result = await provider.blockUser('user-123');
      expect(result, true);
      verify(mockGetBlockedList.call()).called(1);
    });

    test('blockUser returns false on error', () async {
      when(mockBlockUser.call(any)).thenThrow(Exception('error'));

      final result = await provider.blockUser('user-123');
      expect(result, false);
      expect(provider.hasError, true);
    });
  });

  group('User Unblocking', () {
    test('unblockUser returns true on success', () async {
      when(mockUnblockUser.call(any)).thenAnswer((_) async => true);
      when(
        mockGetBlockedList.call(),
      ).thenAnswer((_) async => [testBlockedUser]);

      final result = await provider.unblockUser('user-123');
      expect(result, true);
      verify(mockGetBlockedList.call()).called(1);
    });

    test('unblockUser returns false on error', () async {
      when(mockUnblockUser.call(any)).thenThrow(Exception('error'));

      final result = await provider.unblockUser('user-123');
      expect(result, false);
      expect(provider.hasError, true);
    });
  });

  group('Reporting', () {
    const testReason = 'Inappropriate content';

    test('reportReason updates correctly', () {
      provider.reportReason = testReason;
      expect(provider.reportReason, testReason);
    });

    test('reportReasonSelected updates correctly', () {
      provider.reportReasonSelected = true;
      expect(provider.reportReasonSelected, true);
    });

    test('reportPost returns false when no reason selected', () async {
      provider.reportReason = null;
      final result = await provider.reportPost('post-123');
      expect(result, false);
      verifyNever(mockReportPost.call(any, any));
    });

    test('reportPost returns true on success', () async {
      provider.reportReason = testReason;
      when(mockReportPost.call(any, any)).thenAnswer((_) async => true);
      when(
        mockGetBlockedList.call(),
      ).thenAnswer((_) async => [testBlockedUser]);

      final result = await provider.reportPost('post-123');
      expect(result, true);
      verify(mockReportPost.call('post-123', testReason)).called(1);
    });

    test('reportUser returns false when no reason selected', () async {
      provider.reportReason = null;
      final result = await provider.reportUser('user-123');
      expect(result, false);
      verifyNever(mockReportUser.call(any, any));
    });

    test('reportUser returns true on success', () async {
      provider.reportReason = testReason;
      when(mockReportUser.call(any, any)).thenAnswer((_) async => true);
      when(
        mockGetBlockedList.call(),
      ).thenAnswer((_) async => [testBlockedUser]);

      final result = await provider.reportUser('user-123');
      expect(result, true);
      verify(mockReportUser.call('user-123', testReason)).called(1);
    });
  });
}
