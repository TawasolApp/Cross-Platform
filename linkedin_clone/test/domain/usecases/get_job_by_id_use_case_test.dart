import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/get_job_by_id_use_case.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_job_repository.mocks.dart';

void main() {
  late GetJobByIdUseCase useCase;
  late MockJobRepository mockRepo;

  setUp(() {
    mockRepo = MockJobRepository();
    useCase = GetJobByIdUseCase(mockRepo);
  });

  final job = Job(
    id: '1',
    position: 'Software Engineer',
    company: 'Tawasol Inc',
    industry: 'Technology',
    description: 'Build apps.',
    location: 'Remote',
    salary: 80000.0,
    experienceLevel: 'Senior',
    locationType: 'Remote',
    employmentType: 'Full-time',
    postedDate: DateTime.now(),
    applicantCount: 5,
    isOpen: true,
    companyId: 'comp-123',
    companyName: 'Tawasol Inc',
    companyLogo: '',
    companyAddress: 'Cairo, Egypt',
    companyLocation: 'Cairo',
    companyDescription: 'We build great things.',
    applicationLink: 'https://example.com/apply',
    isSaved: false,
    status: 'active',
  );

  test('returns job when found', () async {
    when(mockRepo.getJobById('1')).thenAnswer((_) async => job);

    final result = await useCase('1');

    expect(result, equals(job));
    verify(mockRepo.getJobById('1')).called(1);
  });

  test('throws exception when not found', () async {
    when(mockRepo.getJobById('404')).thenThrow(Exception('Job not found'));

    expect(() => useCase('404'), throwsException);
    verify(mockRepo.getJobById('404')).called(1);
  });
}
