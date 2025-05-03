import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/delete_job_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late DeleteJob useCase;
  late MockJobRepository mockJobRepository;

  setUp(() {
    mockJobRepository = MockJobRepository();
    useCase = DeleteJob(mockJobRepository);
  });

  test('returns true when job is successfully deleted', () async {
    when(mockJobRepository.deleteJob('1')).thenAnswer((_) async => true);

    final result = await useCase('1');

    expect(result, true);
    verify(mockJobRepository.deleteJob('1')).called(1);
  });

  test('returns false when job deletion fails', () async {
    when(mockJobRepository.deleteJob('1')).thenAnswer((_) async => false);

    final result = await useCase('1');

    expect(result, false);
    verify(mockJobRepository.deleteJob('1')).called(1);
  });
}
