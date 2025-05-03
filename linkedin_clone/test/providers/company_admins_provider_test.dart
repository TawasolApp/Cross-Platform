import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/geta_all_company_admins.dart';
import 'package:linkedin_clone/features/company/domain/usecases/search_users_use_case.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_admins_provider.dart';

class MockAddAdminUseCase extends Mock implements AddAdminUseCase {}
class MockFetchAdminsUseCase extends Mock implements FetchCompanyAdminsUseCase {}
class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}

void main() {
  late CompanyAdminsProvider provider;
  late MockAddAdminUseCase mockAddAdmin;
  late MockFetchAdminsUseCase mockFetchAdmins;
  late MockSearchUsersUseCase mockSearchUsers;

  const testCompanyId = 'company123';
  const testUserId = 'userABC';

  final testUser = User(userId: '1', firstName: 'Test User',headline: 'test',lastName: 'lol', profilePicture: '');
  final testAdmin = User(userId: '2', firstName: 'Admin', headline: 'admin', lastName: 'lol', profilePicture: '');

  setUp(() {
    mockAddAdmin = MockAddAdminUseCase();
    mockFetchAdmins = MockFetchAdminsUseCase();
    mockSearchUsers = MockSearchUsersUseCase();

    provider = CompanyAdminsProvider(
      addAdminUseCase: mockAddAdmin,
      fetchAdminsUseCase: mockFetchAdmins,
      searchUsersUseCase: mockSearchUsers,
    );
  });

  testWidgets('searchUsers populates user list', (tester) async {
    when(() => mockSearchUsers.execute('test'))
        .thenAnswer((_) async => [testUser]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.searchUsers('test');
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.users, [testUser]);
    expect(provider.errorMessage, '');
  });

  testWidgets('fetchAdmins sets companyAdmins and resets page', (tester) async {
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenAnswer((_) async => [testAdmin]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchAdmins(testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.companyAdmins, [testAdmin]);
    expect(provider.allLoaded, false);
  });

  testWidgets('loadMoreAdmins appends more admins and stops at empty', (tester) async {
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenAnswer((_) async => [testAdmin]);
    when(() => mockFetchAdmins.execute(testCompanyId, page: 2, limit: 5))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchAdmins(testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    await provider.loadMoreAdmins();
    await tester.pump();

    expect(provider.companyAdmins.length, 1);
    expect(provider.allLoaded, true);
  });

  testWidgets('addAdmin calls use case and refreshes list', (tester) async {
    when(() => mockAddAdmin(testUserId, testCompanyId)).thenAnswer((_) async => {});
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenAnswer((_) async => [testAdmin]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.addAdmin(testUserId, testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    verify(() => mockAddAdmin(testUserId, testCompanyId)).called(1);
    expect(provider.companyAdmins, [testAdmin]);
  });

  testWidgets('fetchAdmins sets allLoaded when no results', (tester) async {
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchAdmins(testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.companyAdmins, isEmpty);
    expect(provider.allLoaded, true);
  });

  testWidgets('handles error during fetchAdmins', (tester) async {
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenThrow(Exception('fail'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchAdmins(testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.errorMessage, 'Failed to load admins');
  });

  testWidgets('handles error during loadMoreAdmins', (tester) async {
    when(() => mockFetchAdmins.execute(testCompanyId, page: 1, limit: 5))
        .thenAnswer((_) async => [testAdmin]);
    when(() => mockFetchAdmins.execute(testCompanyId, page: 2, limit: 5))
        .thenThrow(Exception('fail'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchAdmins(testCompanyId);
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();
    await provider.loadMoreAdmins();
    await tester.pump();

    expect(provider.errorMessage, 'Failed to load more admins');
  });
}
