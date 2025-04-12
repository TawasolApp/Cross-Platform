import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Mock class
class MockGetAllCompaniesUseCase extends Mock
    implements GetAllCompaniesUseCase {}

void main() {
  late MockGetAllCompaniesUseCase mockUseCase;
  late CompanyListProvider provider;

  setUp(() {
    mockUseCase = MockGetAllCompaniesUseCase();
    provider = CompanyListProvider(getAllCompaniesUseCase: mockUseCase);
  });

  testWidgets('fetchCompanies sets companies list on success', (
    WidgetTester tester,
  ) async {
    final mockCompanies = [
      Company(
        companyId: '1',
        name: 'Company 1',
        industry: 'Tech',
        companySize: '51-200',
        companyType: 'Private',
      ),
      Company(
        companyId: '2',
        name: 'Company 2',
        industry: 'Finance',
        companySize: '201-500',
        companyType: 'Public',
      ),
    ];

    when(
      () => mockUseCase.execute(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => mockCompanies);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              provider.fetchCompanies('test');
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pump(); // Allow post frame callbacks to execute

    expect(provider.companies, mockCompanies);
    expect(provider.isLoading, false);
    expect(provider.error, isNull);
  });

  testWidgets('fetchCompanies handles empty result and sets isAllLoaded', (
    WidgetTester tester,
  ) async {
    when(
      () => mockUseCase.execute(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              provider.fetchCompanies('test');
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pump();

    expect(provider.companies, isEmpty);
    expect(provider.isAllLoaded, true);
  });

  testWidgets('fetchCompanies sets error on failure', (
    WidgetTester tester,
  ) async {
    when(
      () => mockUseCase.execute(
        any(),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenThrow(Exception('Failed to fetch'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              provider.fetchCompanies('test');
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pump();

    expect(provider.error, isNotNull);
    expect(provider.companies, isEmpty);
  });

  testWidgets('loadMoreCompanies appends to companies list', (
    WidgetTester tester,
  ) async {
    final firstPage = [
      Company(
        companyId: '1',
        name: 'Company 1',
        industry: 'Tech',
        companySize: '51-200',
        companyType: 'Private',
      ),
    ];
    final secondPage = [
      Company(
        companyId: '2',
        name: 'Company 2',
        industry: 'Finance',
        companySize: '201-500',
        companyType: 'Public',
      ),
    ];

    when(
      () => mockUseCase.execute(any(), page: 1, limit: any(named: 'limit')),
    ).thenAnswer((_) async => firstPage);

    when(
      () => mockUseCase.execute(any(), page: 2, limit: any(named: 'limit')),
    ).thenAnswer((_) async => secondPage);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              provider.fetchCompanies('test');
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.runAsync(() async {
      await provider.loadMoreCompanies('test');
    });

    await tester.pump();

    expect(provider.companies.length, 2);
    expect(provider.companies[0].companyId, '1');
    expect(provider.companies[1].companyId, '2');
  });

  test('resetProvider clears data and resets flags', () {
    provider.resetProvider();
    expect(provider.companies, isEmpty);
    expect(provider.isLoading, false);
    expect(provider.error, isNull);
    expect(provider.isAllLoaded, false);
  });
}
