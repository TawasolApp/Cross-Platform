import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/saved_jobs_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_jobs_provider_test.mocks.dart';

@GenerateMocks([JobRepository])
void main() {
  late SavedJobsProvider provider;
  late MockJobRepository mockRepository;

  const testJobId = 'job-1';

  setUp(() {
    mockRepository = MockJobRepository();
    provider = SavedJobsProvider(repository: mockRepository);
  });

  test('loads initial saved jobs correctly', () {
    provider.loadInitialSavedJobs(['job-1', 'job-2']);

    expect(provider.isSaved('job-1'), true);
    expect(provider.isSaved('job-2'), true);
    expect(provider.isSaved('job-3'), false);
  });

  test('saves a job successfully', () async {
    when(mockRepository.saveJob(testJobId)).thenAnswer((_) async => true);

    await provider.toggleSave(testJobId);

    expect(provider.isSaved(testJobId), true);
    verify(mockRepository.saveJob(testJobId)).called(1);
  });

  test('unsaves a job successfully', () async {
    provider.loadInitialSavedJobs([testJobId]);
    when(mockRepository.unsaveJob(testJobId)).thenAnswer((_) async => true);

    await provider.toggleSave(testJobId);

    expect(provider.isSaved(testJobId), false);
    verify(mockRepository.unsaveJob(testJobId)).called(1);
  });

  test('does not update state when saveJob fails', () async {
    when(mockRepository.saveJob(testJobId)).thenAnswer((_) async => false);

    await provider.toggleSave(testJobId);

    expect(provider.isSaved(testJobId), false); // not added
    verify(mockRepository.saveJob(testJobId)).called(1);
  });

  test('does not update state when unsaveJob fails', () async {
    provider.loadInitialSavedJobs([testJobId]);
    when(mockRepository.unsaveJob(testJobId)).thenAnswer((_) async => false);

    await provider.toggleSave(testJobId);

    expect(provider.isSaved(testJobId), true); // still saved
    verify(mockRepository.unsaveJob(testJobId)).called(1);
  });
}
