import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/save_job_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late SaveJobUseCase useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = SaveJobUseCase(repository: mockRepo);
  });

  const jobId = 'job-123';

  test('returns true when job is saved successfully', () async {
    when(mockRepo.saveJob(jobId)).thenAnswer((_) async => true);

    final result = await useCase(jobId);

    expect(result, true);
    verify(mockRepo.saveJob(jobId)).called(1);
  });

  test('returns false when saving job fails', () async {
    when(mockRepo.saveJob(jobId)).thenAnswer((_) async => false);

    final result = await useCase(jobId);

    expect(result, false);
    verify(mockRepo.saveJob(jobId)).called(1);
  });
}
