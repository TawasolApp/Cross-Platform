import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/get_applicants_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late GetApplicantsUseCase useCase;
  late MockJobRepository mockJobRepository;

  setUp(() {
    mockJobRepository = MockJobRepository();
    useCase = GetApplicantsUseCase(repository: mockJobRepository);
  });

  const jobId = 'job-123';
  final applicants = [
    ApplicationEntity(
      applicationId: 'app-001',
      applicantId: 'user-123',
      applicantName: 'John Doe',
      applicantEmail: 'john@example.com',
      applicantPicture: 'https://example.com/john.png',
      applicantHeadline: 'Flutter Developer',
      applicantPhoneNumber: '1234567890',
      resumeUrl: 'https://example.com/resume.pdf',
      status: 'pending',
      appliedDate: DateTime.now(),
    ),
    ApplicationEntity(
      applicationId: 'app-001',
      applicantId: 'user-123',
      applicantName: 'John Doe',
      applicantEmail: 'john@example.com',
      applicantPicture: 'https://example.com/john.png',
      applicantHeadline: 'Flutter Developer',
      applicantPhoneNumber: '1234567890',
      resumeUrl: 'https://example.com/resume.pdf',
      status: 'pending',
      appliedDate: DateTime.now(),
    ),
  ];

  test('returns list of applicants when found', () async {
    when(
      mockJobRepository.getApplicants(jobId, page: 1, limit: 5),
    ).thenAnswer((_) async => applicants);

    final result = await useCase(jobId);

    expect(result, applicants);
    verify(mockJobRepository.getApplicants(jobId, page: 1, limit: 5)).called(1);
  });

  test('returns empty list when no applicants found', () async {
    when(
      mockJobRepository.getApplicants(jobId, page: 1, limit: 5),
    ).thenAnswer((_) async => []);

    final result = await useCase(jobId);

    expect(result, isEmpty);
    verify(mockJobRepository.getApplicants(jobId, page: 1, limit: 5)).called(1);
  });
}
