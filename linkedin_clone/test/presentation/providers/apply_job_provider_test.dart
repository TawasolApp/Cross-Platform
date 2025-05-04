import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/apply_for_job_use_case.dart';
import 'package:linkedin_clone/features/jobs/presentation/providers/job_apply_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_job_provider_test.mocks.dart';


@GenerateMocks([ApplyForJobUseCase])
void main() {
  late ApplyJobProvider provider;
  late MockApplyForJobUseCase mockApplyUseCase;

  final mockApplication = ApplyForJobEntity(
    jobId: 'job-1',
    phoneNumber: '1234567890',
    resumeURL: 'https://example.com/resume.pdf',
  );

  setUp(() {
    mockApplyUseCase = MockApplyForJobUseCase();
    provider = ApplyJobProvider(applyForJobUseCase: mockApplyUseCase);
  });

  test('applyForJob sets isLoading to true during call and false after', () async {
    when(mockApplyUseCase.call(mockApplication)).thenAnswer((_) async {
      expect(provider.isLoading, true); // isLoading during await
      return true;
    });

    final result = await provider.applyForJob(mockApplication);

    expect(result, true);
    expect(provider.isLoading, false); // isLoading after call
    verify(mockApplyUseCase.call(mockApplication)).called(1);
  });

  test('applyForJob returns false when usecase fails', () async {
    when(mockApplyUseCase.call(mockApplication)).thenAnswer((_) async => false);

    final result = await provider.applyForJob(mockApplication);

    expect(result, false);
    expect(provider.isLoading, false);
    verify(mockApplyUseCase.call(mockApplication)).called(1);
  });

  test('applyForJob throws if usecase throws', () async {
    when(mockApplyUseCase.call(mockApplication))
        .thenThrow(Exception('Failed to apply'));

    expect(() => provider.applyForJob(mockApplication), throwsException);
    expect(provider.isLoading, false);
  });
}
