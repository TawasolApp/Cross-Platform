import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/unsave_job_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late UnsaveJobUseCase useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = UnsaveJobUseCase(repository: mockRepo);
  });

  const jobId = 'job-123';

  test('returns true when job is successfully unsaved', () async {
    when(mockRepo.unsaveJob(jobId)).thenAnswer((_) async => true);

    final result = await useCase(jobId);

    expect(result, true);
    verify(mockRepo.unsaveJob(jobId)).called(1);
  });

  test('returns false when unsave operation fails', () async {
    when(mockRepo.unsaveJob(jobId)).thenAnswer((_) async => false);

    final result = await useCase(jobId);

    expect(result, false);
    verify(mockRepo.unsaveJob(jobId)).called(1);
  });
}
