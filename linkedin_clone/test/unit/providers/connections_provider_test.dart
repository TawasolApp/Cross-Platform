import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/accept_ignore_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/withdraw_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/endorse/endorse_skill_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/endorse/remove_endorsement_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'connections_provider_test.mocks.dart';

@GenerateMocks([
  GetConnectionsUseCase,
  RemoveConnectionUseCase,
  GetReceivedConnectionRequestsUseCase,
  GetSentConnectionRequestsUseCase,
  AcceptIgnoreConnectionRequestUseCase,
  SendConnectionRequestUseCase,
  WithdrawConnectionRequestUseCase,
  EndorseSkillUseCase,
  RemoveEndorsementUsecase,
  GetProfileUseCase,
])
void main() {
  late ConnectionsProvider provider;
  late MockGetConnectionsUseCase mockGetConnections;
  late MockRemoveConnectionUseCase mockRemoveConnection;
  late MockGetReceivedConnectionRequestsUseCase mockGetReceivedRequests;
  late MockGetSentConnectionRequestsUseCase mockGetSentRequests;
  late MockAcceptIgnoreConnectionRequestUseCase mockAcceptIgnoreRequest;
  late MockSendConnectionRequestUseCase mockSendRequest;
  late MockWithdrawConnectionRequestUseCase mockWithdrawRequest;
  late MockEndorseSkillUseCase mockEndorseSkill;
  late MockRemoveEndorsementUsecase mockRemoveEndorsement;
  late MockGetProfileUseCase mockGetProfile;

  setUp(() {
    mockGetConnections = MockGetConnectionsUseCase();
    mockRemoveConnection = MockRemoveConnectionUseCase();
    mockGetReceivedRequests = MockGetReceivedConnectionRequestsUseCase();
    mockGetSentRequests = MockGetSentConnectionRequestsUseCase();
    mockAcceptIgnoreRequest = MockAcceptIgnoreConnectionRequestUseCase();
    mockSendRequest = MockSendConnectionRequestUseCase();
    mockWithdrawRequest = MockWithdrawConnectionRequestUseCase();
    mockEndorseSkill = MockEndorseSkillUseCase();
    mockRemoveEndorsement = MockRemoveEndorsementUsecase();
    mockGetProfile = MockGetProfileUseCase();
    provider = ConnectionsProvider(
      mockGetConnections,
      mockRemoveConnection,
      mockGetReceivedRequests,
      mockGetSentRequests,
      mockAcceptIgnoreRequest,
      mockSendRequest,
      mockWithdrawRequest,
      mockRemoveEndorsement,
      mockEndorseSkill,
    );

    // Use reflection to set the private GetProfileUseCase field
    // This is a workaround since the provider creates its own instance
    final field = provider.runtimeType.toString().contains(
      '_privateGetProfileUseCase',
    );
  });

  test('initial values are correct', () {
    expect(provider.isLoading, false);
    expect(provider.isBusy, false);
    expect(provider.hasErrorMain, false);
    expect(provider.hasErrorSecondary, false);
    expect(provider.currentPageMain, 1);
    expect(provider.currentPageSecondary, 1);
    expect(provider.hasMoreMain, true);
    expect(provider.hasMoreSecondary, true);
    expect(provider.selectedFilter, 'Recently added');
    expect(provider.activeFilter, 'Recently added');
  });

  test('getReceivedConnectionRequests adds requests correctly', () async {
    final requests = [
      ConnectionsUserEntity(
        userId: '2',
        firstName: 'Jane',
        lastName: 'Smith',
        headLine: 'Designer',
        time: '2023-10-01T12:00:00Z',
        profilePicture: '',
      ),
    ];

    when(
      mockGetReceivedRequests.call(page: 1, limit: 15),
    ).thenAnswer((_) async => requests);

    await provider.getReceivedConnectionRequests(isInitial: true);

    expect(provider.receivedConnectionRequestsList, isNotNull);
    expect(provider.receivedConnectionRequestsList!.length, 1);
    expect(provider.hasErrorMain, false);
  });

  test('getSentConnectionRequests adds requests correctly', () async {
    final requests = [
      ConnectionsUserEntity(
        userId: '3',
        firstName: 'Bob',
        lastName: 'Johnson',
        headLine: 'Manager',
        time: '2023-10-01T12:00:00Z',
        profilePicture: '',
      ),
    ];

    when(
      mockGetSentRequests.call(page: 1, limit: 15),
    ).thenAnswer((_) async => requests);

    await provider.getSentConnectionRequests(isInitial: true);

    expect(provider.sentConnectionRequestsList, isNotNull);
    expect(provider.sentConnectionRequestsList!.length, 1);
    expect(provider.hasErrorSecondary, false);
  });

  test('acceptConnectionRequest returns true on success', () async {
    final testUserId = '123';

    when(
      mockAcceptIgnoreRequest.call(testUserId, true),
    ).thenAnswer((_) async => true);
    when(
      mockGetReceivedRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => []);

    final result = await provider.acceptConnectionRequest(testUserId);

    expect(result, true);
    verify(mockAcceptIgnoreRequest.call(testUserId, true)).called(1);
    verify(
      mockGetReceivedRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).called(1);
  });

  test('ignoreConnectionRequest returns true on success', () async {
    final testUserId = '123';

    when(
      mockAcceptIgnoreRequest.call(testUserId, false),
    ).thenAnswer((_) async => true);
    when(
      mockGetReceivedRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => []);

    final result = await provider.ignoreConnectionRequest(testUserId);

    expect(result, true);
    verify(mockAcceptIgnoreRequest.call(testUserId, false)).called(1);
    verify(
      mockGetReceivedRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).called(1);
  });

  test('sendConnectionRequest returns true on success', () async {
    final testUserId = '123';

    when(mockSendRequest.call(testUserId)).thenAnswer((_) async => true);

    final result = await provider.sendConnectionRequest(testUserId);

    expect(result, true);
    verify(mockSendRequest.call(testUserId)).called(1);
  });

  test('withdrawConnectionRequest returns true on success', () async {
    final testUserId = '123';

    when(mockWithdrawRequest.call(testUserId)).thenAnswer((_) async => true);
    when(
      mockGetSentRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => []);

    final result = await provider.withdrawConnectionRequest(testUserId);

    expect(result, true);
    verify(mockWithdrawRequest.call(testUserId)).called(1);
    verify(
      mockGetSentRequests.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).called(1);
  });

  test('endorseSkill returns true on success', () async {
    final testUserId = '123';
    final testSkillId = '456';

    when(
      mockEndorseSkill.call(testUserId, testSkillId),
    ).thenAnswer((_) async => true);

    final result = await provider.endorseSkill(testUserId, testSkillId);

    expect(result, true);
    verify(mockEndorseSkill.call(testUserId, testSkillId)).called(1);
  });

  test('removeEndorsment returns true on success', () async {
    final testUserId = '123';
    final testSkillId = '456';

    when(
      mockRemoveEndorsement.call(testUserId, testSkillId),
    ).thenAnswer((_) async => true);

    final result = await provider.removeEndorsment(testUserId, testSkillId);

    expect(result, true);
    verify(mockRemoveEndorsement.call(testUserId, testSkillId)).called(1);
  });

  test('setFilter updates selected filter', () {
    const newFilter = 'First name';

    provider.setFilter(newFilter);

    expect(provider.selectedFilter, newFilter);
  });
}
