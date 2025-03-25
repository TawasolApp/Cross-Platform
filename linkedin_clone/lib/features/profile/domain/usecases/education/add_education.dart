import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class AddEducationUseCase implements UseCase<void, Education> {
  final ProfileRepository repository;

  AddEducationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Education education) {
    return repository.addEducation(education);
  }
}