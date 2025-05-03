import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/apply_for_job_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late ApplyForJobUseCase useCase;
  late MockJobRepository mockJobRepository;

  setUp(() {
    mockJobRepository = MockJobRepository();
    useCase = ApplyForJobUseCase(repository: mockJobRepository);
  });

  final application = ApplyForJobEntity(
    jobId: 'job-1',
    phoneNumber: '1234567890',
    resumeURL: 'https://example.com/resume.pdf',
  );

  test('returns true when job application is successful', () async {
    when(
      mockJobRepository.applyForJob(application),
    ).thenAnswer((_) async => true);

    final result = await useCase(application);
    print('✅ Result: $result');

    expect(result, true);
    verify(mockJobRepository.applyForJob(application)).called(1);
  });

  test('returns false when job application fails', () async {
    when(
      mockJobRepository.applyForJob(application),
    ).thenAnswer((_) async => false);

    final result = await useCase(application);
    print('❌ Result: $result');

    expect(result, false);
    verify(mockJobRepository.applyForJob(application)).called(1);
  });
}
