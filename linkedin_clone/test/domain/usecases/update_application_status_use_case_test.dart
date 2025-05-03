import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/update_application_status_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late UpdateApplicationStatusUseCase useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = UpdateApplicationStatusUseCase(repository: mockRepo);
  });

  const applicationId = 'app-456';
  const newStatus = 'accepted';

  test('returns true when application status is successfully updated', () async {
    when(mockRepo.updateApplicationStatus(applicationId, newStatus))
        .thenAnswer((_) async => true);

    final result = await useCase(applicationId, newStatus);

    expect(result, true);
    verify(mockRepo.updateApplicationStatus(applicationId, newStatus)).called(1);
  });

  test('returns false when application status update fails', () async {
    when(mockRepo.updateApplicationStatus(applicationId, newStatus))
        .thenAnswer((_) async => false);

    final result = await useCase(applicationId, newStatus);

    expect(result, false);
    verify(mockRepo.updateApplicationStatus(applicationId, newStatus)).called(1);
  });
}
