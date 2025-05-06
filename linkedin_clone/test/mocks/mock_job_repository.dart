import 'package:linkedin_clone/features/jobs/domain/usecases/get_applicants_use_case.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/update_application_status_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

@GenerateMocks([JobRepository,GetApplicantsUseCase, UpdateApplicationStatusUseCase])
void main() {}