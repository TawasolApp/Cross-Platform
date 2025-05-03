import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies_usecase.dart';
import 'package:linkedin_clone/features/company/presentation/providers/related_companies_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockGetRelatedCompanies extends Mock implements GetRelatedCompanies {}

void main() {
  late RelatedCompaniesProvider provider;
  late MockGetRelatedCompanies mockUseCase;

  setUp(() {
    mockUseCase = MockGetRelatedCompanies();
    provider = RelatedCompaniesProvider(getRelatedCompaniesUseCase: mockUseCase);
  });

  testWidgets('fetchRelatedCompanies loads data successfully on first page', (tester) async {
    provider.setCompanyId('test-companyId');

    final companies = [
      Company(
        companyId: '1',
        name: 'Company 1',
        industry: 'Tech',
        companySize: '1-10',
        companyType: 'Private',
      ),
    ];

    when(() => mockUseCase.execute('test-companyId', page: 1, limit: 5))
        .thenAnswer((_) async => companies);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: Builder(builder: (context) {
            provider.fetchRelatedCompanies();
            return const SizedBox();
          }),
        ),
      ),
    );

    await tester.pump(); // allow provider to notify

    expect(provider.relatedCompanies, companies);
    expect(provider.isLoadingState, false);
    expect(provider.allLoaded, false);
  });

  testWidgets('fetchRelatedCompanies appends companies on pagination', (tester) async {
    provider.setCompanyId('test-companyId');

    final firstPage = [
      Company(
        companyId: '1',
        name: 'Company 1',
        industry: 'Tech',
        companySize: '1-10',
        companyType: 'Private',
      ),
    ];
    final secondPage = [
      Company(
        companyId: '2',
        name: 'Company 2',
        industry: 'Health',
        companySize: '11-50',
        companyType: 'Public',
      ),
    ];

    when(() => mockUseCase.execute('test-companyId', page: 1, limit: 5)).thenAnswer((_) async => firstPage);
    when(() => mockUseCase.execute('test-companyId', page: 2, limit: 5)).thenAnswer((_) async => secondPage);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchRelatedCompanies();
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    await tester.runAsync(() async {
      await provider.loadMoreCompanies();
    });

    await tester.pump();

    expect(provider.relatedCompanies.length, 2);
    expect(provider.relatedCompanies[1].companyId, '2');
  });

  testWidgets('fetchRelatedCompanies sets allLoaded on empty result', (tester) async {
    provider.setCompanyId('test-companyId');

    when(() => mockUseCase.execute('test-companyId', page: 1, limit: 5))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchRelatedCompanies();
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.relatedCompanies, isEmpty);
    expect(provider.allLoaded, true);
  });

  test('resetProvider clears data', () {
    provider.setCompanyId('test-companyId');
    provider.resetProvider();

    expect(provider.relatedCompanies, isEmpty);
    expect(provider.allLoaded, false);
  });

  testWidgets('fetchRelatedCompanies does not fetch if companyId is null', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: SizedBox()),
      ),
    );

    await provider.fetchRelatedCompanies();

    verifyNever(() => mockUseCase.execute(any(), page: any(named: 'page'), limit: any(named: 'limit')));
  });

  testWidgets('fetchRelatedCompanies handles error gracefully', (tester) async {
    provider.setCompanyId('test-companyId');

    when(() => mockUseCase.execute('test-companyId', page: 1, limit: 5)).thenThrow(Exception('Something went wrong'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: Builder(builder: (context) {
          provider.fetchRelatedCompanies();
          return const SizedBox();
        })),
      ),
    );

    await tester.pump();

    expect(provider.isLoadingState, false);
    expect(provider.relatedCompanies, isEmpty);
  });
}
