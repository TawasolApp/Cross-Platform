import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_details_provider.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/get_job_by_id_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late JobDetailsProvider provider;
  late GetJobByIdUseCase useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = GetJobByIdUseCase(mockRepo);
    provider = JobDetailsProvider(mockRepo);
  });

  final job = Job(
    id: '1',
    position: 'Software Engineer',
    company: 'Tawasol Inc',
    industry: 'Technology',
    description: 'Develop cutting-edge Flutter apps.',
    location: 'Remote',
    salary: 80000.0,
    experienceLevel: 'Mid-Level',
    locationType: 'Remote',
    employmentType: 'Full-time',
    postedDate: DateTime.now(),
    applicantCount: 10,
    isOpen: true,
    companyId: 'comp-123',
    companyName: 'Tawasol Inc',
    companyLogo: 'https://logo.url/image.png',
    companyAddress: '123 Main St, Cairo',
    companyLocation: 'Cairo, Egypt',
    companyDescription: 'Innovating in the tech space.',
    applicationLink: 'https://apply.tawasol.com/job/1',
    isSaved: false,
    status: 'active',
  );

  test('fetches job successfully', () async {
    when(mockRepo.getJobById('1')).thenAnswer((_) async => job);

    await provider.fetchJob('1');

    expect(provider.job, job);
    expect(provider.error, isNull);
    expect(provider.isLoading, false);
  });

  test('sets error when fetching job fails', () async {
    when(mockRepo.getJobById('1')).thenThrow(Exception('Job not found'));

    await provider.fetchJob('1');

    expect(provider.job, isNull);
    expect(provider.error, isNotNull);
    expect(provider.isLoading, false);
  });

  test('isLoading is true during fetch and false after', () async {
    when(mockRepo.getJobById('1')).thenAnswer((_) async {
      expect(provider.isLoading, true);
      return job;
    });

    await provider.fetchJob('1');

    expect(provider.isLoading, false);
  });

  test('does not modify job if fetch fails', () async {
    when(mockRepo.getJobById('1')).thenThrow(Exception('Failed'));

    await provider.fetchJob('1');

    expect(provider.job, isNull);
    expect(provider.error, isNotNull);
  });
  
}
