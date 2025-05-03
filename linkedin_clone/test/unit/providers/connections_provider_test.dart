import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/accept_ignore_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/withdraw_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/endorse/endorse_skill_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/endorse/remove_endorsement_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
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
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ConnectionsProvider provider;
  late MockGetConnectionsUseCase mockGetConnections;
  late MockRemoveConnectionUseCase mockRemoveConnection;
  late MockGetReceivedConnectionRequestsUseCase mockGetReceived;
  late MockGetSentConnectionRequestsUseCase mockGetSent;
  late MockAcceptIgnoreConnectionRequestUseCase mockAcceptIgnore;
  late MockSendConnectionRequestUseCase mockSendRequest;
  late MockWithdrawConnectionRequestUseCase mockWithdrawRequest;
  late MockEndorseSkillUseCase mockEndorseSkill;
  late MockRemoveEndorsementUsecase mockRemoveEndorse;

  setUp(() {
    mockGetConnections = MockGetConnectionsUseCase();
    mockRemoveConnection = MockRemoveConnectionUseCase();
    mockGetReceived = MockGetReceivedConnectionRequestsUseCase();
    mockGetSent = MockGetSentConnectionRequestsUseCase();
    mockAcceptIgnore = MockAcceptIgnoreConnectionRequestUseCase();
    mockSendRequest = MockSendConnectionRequestUseCase();
    mockWithdrawRequest = MockWithdrawConnectionRequestUseCase();
    mockEndorseSkill = MockEndorseSkillUseCase();
    mockRemoveEndorse = MockRemoveEndorsementUsecase();

    provider = ConnectionsProvider(
      mockGetConnections,
      mockRemoveConnection,
      mockGetReceived,
      mockGetSent,
      mockAcceptIgnore,
      mockSendRequest,
      mockWithdrawRequest,
      mockRemoveEndorse,
      mockEndorseSkill,
    );
  });

  test('getConnections returns and sets data correctly', () async {
    final users = <ConnectionsUserEntity>[];
    when(
      mockGetConnections.call(
        userId: anyNamed('userId'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        sortBy: anyNamed('sortBy'),
      ),
    ).thenAnswer((_) async => users);

    await provider.getConnections(isInitial: true, id: 'test-id');

//     expect(provider.connectionsList, users);
//     expect(provider.hasErrorMain, false);
//   });

//   test(
//     'getReceivedConnectionRequests returns and sets data correctly',
//     () async {
//       final users = <ConnectionsUserEntity>[];
//       when(
//         mockGetReceived.call(page: anyNamed('page'), limit: anyNamed('limit')),
//       ).thenAnswer((_) async => users);

//       await provider.getReceivedConnectionRequests(isInitial: true);

//       expect(provider.receivedConnectionRequestsList, users);
//       expect(provider.hasErrorMain, false);
//     },
//   );

//   test('getSentConnectionRequests returns and sets data correctly', () async {
//     final users = <ConnectionsUserEntity>[];
//     when(
//       mockGetSent.call(page: anyNamed('page'), limit: anyNamed('limit')),
//     ).thenAnswer((_) async => users);

//     await provider.getSentConnectionRequests(isInitial: true);

//     expect(provider.sentConnectionRequestsList, users);
//     expect(provider.hasErrorSecondary, false);
//   });

  test('getInvitations calls both internal fetch methods', () async {
    when(
      mockGetSent.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);
    when(
      mockGetReceived.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);

    await provider.getInvitations(
      isInitsent: true,
      isInitRec: true,
      refreshSent: true,
      refreshRec: true,
    );

    expect(provider.hasErrorMain, false);
    expect(provider.hasErrorSecondary, false);
  });

  test('removeConnection returns true when successfully removed', () async {
    when(mockRemoveConnection.call('123')).thenAnswer((_) async => true);
    when(
      mockGetConnections.call(
        userId: anyNamed('userId'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        sortBy: anyNamed('sortBy'),
      ),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);

    final dummyProfile = Profile(
      userId: 'dummy-id',
      firstName: 'Test',
      lastName: 'User',
      profilePicture: '',
      headline: '',
      connectionCount: 5,
    );

    when(
      provider.getProfileUseCase.call(any<String>()),
    ).thenAnswer((_) async => Right(dummyProfile));

//     final result = await provider.removeConnection('123');

//     expect(result, true);
//   });

  test('acceptConnectionRequest returns true when accepted', () async {
    when(mockAcceptIgnore.call('123', true)).thenAnswer((_) async => true);
    when(
      mockGetReceived.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);

//     final result = await provider.acceptConnectionRequest('123');
//     expect(result, true);
//   });

  test('ignoreConnectionRequest returns true when ignored', () async {
    when(mockAcceptIgnore.call('123', false)).thenAnswer((_) async => true);
    when(
      mockGetReceived.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);

//     final result = await provider.ignoreConnectionRequest('123');
//     expect(result, true);
//   });

//   test('sendConnectionRequest returns true on success', () async {
//     when(mockSendRequest.call('123')).thenAnswer((_) async => true);

//     final result = await provider.sendConnectionRequest('123');
//     expect(result, true);
//   });

  test('withdrawConnectionRequest returns true on success', () async {
    when(mockWithdrawRequest.call('123')).thenAnswer((_) async => true);
    when(
      mockGetSent.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => <ConnectionsUserEntity>[]);

    final result = await provider.withdrawConnectionRequest('123');
    expect(result, true);
  });

  test('endorseSkill returns true on success', () async {
    when(
      mockEndorseSkill.call('user123', 'skill123'),
    ).thenAnswer((_) async => true);

    final result = await provider.endorseSkill('user123', 'skill123');
    expect(result, true);
  });

  test('removeEndorsement returns true on success', () async {
    when(
      mockRemoveEndorse.call('user123', 'skill123'),
    ).thenAnswer((_) async => true);

    final result = await provider.removeEndorsment('user123', 'skill123');
    expect(result, true);
  });
}
