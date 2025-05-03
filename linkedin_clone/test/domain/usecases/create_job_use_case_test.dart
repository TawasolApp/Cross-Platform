import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/create_job_posting_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late CreateJob useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = CreateJob(repository: mockRepo);
  });

  const companyId = 'company-1';

  final validJob = CreateJobEntity(
    position: 'Software Engineer',
    industry: 'Tech',
    location: 'Remote',
    description: 'Build cool things',
    salary: 75000.0,
    experienceLevel: 'Mid',
    locationType: 'Remote',
    employmentType: 'Full-time',
  );

  test('creates job successfully', () async {
    when(mockRepo.addJob(validJob, companyId)).thenAnswer((_) async => true);

    await useCase.execute(validJob, companyId);

    verify(mockRepo.addJob(validJob, companyId)).called(1);
  });

  test('throws exception when required fields are empty', () async {
    final invalidJob = CreateJobEntity(
      position: '',
      industry: 'Tech',
      location: '',
      description: '',
      salary: 0,
      experienceLevel: '',
      locationType: '',
      employmentType: '',
    );

    expect(
      () => useCase.execute(invalidJob, companyId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Missing Fields'))),
    );

    verifyNever(mockRepo.addJob(any, any));
  });

  test('throws exception when repository fails to add job', () async {
    when(mockRepo.addJob(validJob, companyId)).thenAnswer((_) async => false);

    expect(
      () => useCase.execute(validJob, companyId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to add job'))),
    );

    verify(mockRepo.addJob(validJob, companyId)).called(1);
  });

  test('rethrows exceptions thrown by repository', () async {
    when(mockRepo.addJob(validJob, companyId)).thenThrow(Exception('Server error'));

    expect(
      () => useCase.execute(validJob, companyId),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Server error'))),
    );

    verify(mockRepo.addJob(validJob, companyId)).called(1);
  });
}
