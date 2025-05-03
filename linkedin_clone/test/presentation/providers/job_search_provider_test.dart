import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/search_jobs_use_case.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_search_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'job_search_provider_test.mocks.dart';

@GenerateMocks([SearchJobs])
void main() {
  late JobSearchProvider provider;
  late MockSearchJobs mockSearchJobs;

  final mockJob = Job(
    id: 'job-1',
    position: 'Software Engineer',
    company: 'Tech Co',
    companyLogo: '',
    location: 'Remote',
    description: 'Test job',
    salary: 10000,
    industry: 'Tech',
    postedDate: DateTime.now(),
    employmentType: 'Full-time',
    experienceLevel: 'Entry-level',
    locationType: 'On-site',
    applicantCount: 0,
    isOpen: true,
    companyId: 'company-1',
    companyName: 'Tech Co',
    companyAddress: '123 Tech Street',
    companyLocation: 'Remote',
    companyDescription: 'A leading tech company',
    applicationLink: 'https://apply.here',
    isSaved: false,
    status: 'Active',
  );

  setUp(() {
    mockSearchJobs = MockSearchJobs();
    provider = JobSearchProvider(searchJobs: mockSearchJobs);
  });

  test('fetches jobs successfully and paginates', () async {
    when(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).thenAnswer((_) async => [mockJob]);

    await provider.fetchJobs(reset: true);

    expect(provider.jobs, contains(mockJob));
    expect(provider.isLoading, false);
    expect(provider.isAllLoaded, false);
  });

  test('sets isAllLoaded true when no jobs returned', () async {
    when(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).thenAnswer((_) async => []);

    await provider.fetchJobs(reset: true);

    expect(provider.isAllLoaded, true);
    expect(provider.jobs.length, 0);
  });

  test('handles exceptions gracefully', () async {
    when(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).thenThrow(Exception('fetch error'));

    await provider.fetchJobs(reset: true);

    expect(provider.jobs.length, 0);
    expect(provider.isLoading, false);
    expect(provider.isAllLoaded, false);
  });

  test('prevents duplicate fetch if already loading or all loaded', () async {
    when(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).thenAnswer((_) async => []);

    await provider.fetchJobs(reset: true);
    expect(provider.isAllLoaded, true);

    await provider.fetchJobs(); // should be blocked

    verify(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).called(1); // only one call allowed
  });

  test('resets provider state properly', () async {
    when(
      mockSearchJobs.call(
        keyword: anyNamed('keyword'),
        location: anyNamed('location'),
        industry: anyNamed('industry'),
        experienceLevel: anyNamed('experienceLevel'),
        company: anyNamed('company'),
        minSalary: anyNamed('minSalary'),
        maxSalary: anyNamed('maxSalary'),
        page: 1,
        limit: 5,
      ),
    ).thenAnswer((_) async => []);

    await provider.fetchJobs(reset: true);
    expect(provider.isAllLoaded, true);

    provider.resetProvider();

    expect(provider.jobs, isEmpty);
    expect(provider.isAllLoaded, false);
  });

  test('sets filters and resets jobs list', () {
    // Populate provider using mock (instead of jobs.add)
    provider.setFilters(keyword: 'flutter', location: 'Cairo', minSalary: 5000);

    expect(provider.jobs, isEmpty); // should be reset
    expect(provider.keyword, 'flutter');
    expect(provider.location, 'Cairo');
    expect(provider.minSalary, 5000);
  });
}
