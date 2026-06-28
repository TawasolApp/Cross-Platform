import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class UpdateCertificationUseCase
    implements UseCase<void, CertificationUpdateParams> {
  final ProfileRepository repository;

  UpdateCertificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CertificationUpdateParams params) {
    return repository.updateCertification(
      params.certificationId,
      params.certification,
    );
  }
}

class CertificationUpdateParams {
  final String certificationId;
  final Certification certification;

  CertificationUpdateParams({
    required this.certificationId,
    required this.certification,
  });
}
