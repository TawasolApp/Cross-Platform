import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/get_applicants_use_case.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/update_application_status_use_case.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_applicants_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_job_repository.mocks.dart';


@GenerateMocks([GetApplicantsUseCase, UpdateApplicationStatusUseCase])
void main() {
  late ApplicantsProvider provider;
  late MockGetApplicantsUseCase mockGetApplicantsUseCase;
  late MockUpdateApplicationStatusUseCase mockUpdateStatusUseCase;

  setUp(() {
    mockGetApplicantsUseCase = MockGetApplicantsUseCase();
    mockUpdateStatusUseCase = MockUpdateApplicationStatusUseCase();
    provider = ApplicantsProvider(
      getApplicantsUseCase: mockGetApplicantsUseCase,
      updateStatusUseCase: mockUpdateStatusUseCase,
    );
  });

  final application = ApplicationEntity(
    applicationId: 'app-1',
    applicantId: 'user-1',
    applicantName: 'Test User',
    applicantEmail: 'test@example.com',
    applicantPicture: '',
    applicantHeadline: 'Student',
    applicantPhoneNumber: '1234567890',
    resumeUrl: 'https://example.com/resume.pdf',
    status: 'pending',
    appliedDate: DateTime.now(),
  );

  test('fetches applicants successfully', () async {
    when(mockGetApplicantsUseCase.call(
      'job-1',
      page: 1,
      limit: 5,
    )).thenAnswer((_) async => [application]);

    await provider.fetchApplicants('job-1', reset: true);

    expect(provider.applications, contains(application));
    expect(provider.isLoading, false);
    expect(provider.error, isNull);
  });

  test('sets isAllLoaded to true when no applicants returned', () async {
    when(mockGetApplicantsUseCase.call(
      'job-1',
      page: 1,
      limit: 5,
    )).thenAnswer((_) async => []);

    await provider.fetchApplicants('job-1', reset: true);

    expect(provider.isAllLoaded, true);
  });

  test('handles error when fetch fails', () async {
    when(mockGetApplicantsUseCase.call(
      'job-1',
      page: 1,
      limit: 5,
    )).thenThrow(Exception('Failed to fetch'));

    await provider.fetchApplicants('job-1', reset: true);

    expect(provider.error, isNotNull);
    expect(provider.applications, isEmpty);
  });

  test('resets applicants properly', () {
    provider.resetApplicants();

    expect(provider.applications, isEmpty);
    expect(provider.isLoading, false);
    expect(provider.error, isNull);
  });

  test('updates status of applicant successfully', () async {
    provider.applications.add(application);

    when(mockUpdateStatusUseCase.call('app-1', 'accepted'))
        .thenAnswer((_) async => true);

    final result = await provider.updateStatus('app-1', 'accepted');

    expect(result, true);
    expect(provider.applications.first.status, 'accepted');
  });

  test('does not update status when usecase fails', () async {
    provider.applications.add(application);

    when(mockUpdateStatusUseCase.call('app-1', 'rejected'))
        .thenAnswer((_) async => false);

    final result = await provider.updateStatus('app-1', 'rejected');

    expect(result, false);
    expect(provider.applications.first.status, 'pending');
  });
}
