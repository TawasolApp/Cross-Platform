import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_list_user_entity.dart';

import 'connections_provider_test.mocks.dart';

@GenerateMocks([GetConnectionsUseCase, RemoveConnectionUseCase])
void main() {
  late ConnectionsProvider provider;
  late MockGetConnectionsUseCase mockGetConnectionsUseCase;
  late MockRemoveConnectionUseCase mockRemoveConnectionUseCase;

  setUp(() {
    mockGetConnectionsUseCase = MockGetConnectionsUseCase();
    mockRemoveConnectionUseCase = MockRemoveConnectionUseCase();
    provider = ConnectionsProvider(
      mockGetConnectionsUseCase,
      mockRemoveConnectionUseCase,
    );
  });

  group('ConnectionsProvider Tests', () {
    test('should store and retrieve token correctly', () {
      provider.setToken('test_token');
      expect(provider.token, 'test_token');

      provider.clearToken();
      expect(provider.token, isNull);
    });

    test('should fetch and return connections list', () async {
      final List<ConnectionsListUserEntity> mockConnections = [
        ConnectionsListUserEntity(
          userId: '1',
          userName: 'John Doe',
          profilePicture: 'https://example.com/image.jpg',
          connectionTime: '2025-03-25T10:00:00Z',
          headLine: "Bla Bla Bla",
        ),
      ];

      when(
        mockGetConnectionsUseCase.call(any),
      ).thenAnswer((_) async => Future.value(mockConnections));

      final result = await provider.getConnections();

      expect(result, mockConnections);
      expect(provider.connectionsList, mockConnections);
    });

    test('should remove connection successfully', () async {
      when(
        mockRemoveConnectionUseCase.call('1', any),
      ).thenAnswer((_) async => Future.value(true));

      final result = await provider.removeConnection('1');

      expect(result, isTrue);
    });
    test('should update filter correctly', () {
      provider.setFilter('First name');
      expect(provider.selectedFilter, 'First name');
    });

    test('should sort connections by date', () {
      final List<ConnectionsListUserEntity> mockConnections = [
        ConnectionsListUserEntity(
          userId: '1',
          userName: 'Alice',
          connectionTime: '2025-03-23T12:00:00Z',
          headLine: "Bla Bla Bla1",
          profilePicture: 'https://example.com/image.jpg',
        ),
        ConnectionsListUserEntity(
          userId: '2',
          userName: 'Bob',
          connectionTime: '2025-03-25T14:00:00Z',
          headLine: "Bla Bla Bla2",
          profilePicture: 'https://example.com/image.jpg',
        ),
      ];

      provider.connectionsList = mockConnections;
      provider.setFilter('Recently added');
      provider.sortConnectionBy('Recently added');

      expect(provider.connectionsList?.first.userId, '2');
    });
  });
}
