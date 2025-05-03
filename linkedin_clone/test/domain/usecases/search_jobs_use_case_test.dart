import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/search_jobs_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late SearchJobs useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = SearchJobs(mockRepo);
  });

  final mockJobs = [
    Job(
      id: 'job-001',
      position: 'Software Developer',
      company: 'Tawasol',
      industry: 'Tech',
      description: 'Build mobile apps',
      location: 'Cairo',
      salary: 90000,
      experienceLevel: 'Mid',
      locationType: 'Remote',
      employmentType: 'Full-time',
      postedDate: DateTime.now(),
      applicantCount: 10,
      isOpen: true,
      companyId: 'comp-001',
      companyName: 'Tawasol',
      companyLogo: '',
      companyAddress: '123 Tech Street',
      companyLocation: 'Cairo, Egypt',
      companyDescription: 'Tech company',
      applicationLink: '',
      isSaved: false,
      status: 'active',
    ),
  ];

  test('returns list of jobs on successful search with all filters', () async {
    when(mockRepo.searchJobs(
      keyword: 'flutter',
      location: 'Cairo',
      industry: 'Tech',
      experienceLevel: 'Mid',
      company: 'Tawasol',
      minSalary: 50000,
      maxSalary: 100000,
      page: 1,
      limit: 5,
    )).thenAnswer((_) async => mockJobs);

    final result = await useCase(
      keyword: 'flutter',
      location: 'Cairo',
      industry: 'Tech',
      experienceLevel: 'Mid',
      company: 'Tawasol',
      minSalary: 50000,
      maxSalary: 100000,
    );

    expect(result, mockJobs);
    verify(mockRepo.searchJobs(
      keyword: 'flutter',
      location: 'Cairo',
      industry: 'Tech',
      experienceLevel: 'Mid',
      company: 'Tawasol',
      minSalary: 50000,
      maxSalary: 100000,
      page: 1,
      limit: 5,
    )).called(1);
  });

  test('returns empty list when no jobs match filters', () async {
    when(mockRepo.searchJobs(
      keyword: 'nonexistent',
      location: 'Nowhere',
      industry: 'Unknown',
      experienceLevel: 'Expert',
      company: 'GhostCorp',
      minSalary: 150000,
      maxSalary: 200000,
      page: 1,
      limit: 5,
    )).thenAnswer((_) async => []);

    final result = await useCase(
      keyword: 'nonexistent',
      location: 'Nowhere',
      industry: 'Unknown',
      experienceLevel: 'Expert',
      company: 'GhostCorp',
      minSalary: 150000,
      maxSalary: 200000,
    );

    expect(result, []);
  });

  test('calls repository with default pagination if not passed', () async {
    when(mockRepo.searchJobs(
      keyword: null,
      location: null,
      industry: null,
      experienceLevel: null,
      company: null,
      minSalary: null,
      maxSalary: null,
      page: 1,
      limit: 5,
    )).thenAnswer((_) async => []);

    final result = await useCase();

    expect(result, []);
    verify(mockRepo.searchJobs(
      keyword: null,
      location: null,
      industry: null,
      experienceLevel: null,
      company: null,
      minSalary: null,
      maxSalary: null,
      page: 1,
      limit: 5,
    )).called(1);
  });
}
