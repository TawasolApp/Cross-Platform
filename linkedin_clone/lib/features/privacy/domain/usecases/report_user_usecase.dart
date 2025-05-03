import 'package:linkedin_clone/features/privacy/domain/repository/privacy_repository.dart';

class ReportUserUseCase {
  final PrivacyRepository repository;

  ReportUserUseCase(this.repository);

  Future<bool> call(String userId, String reason) async {
    return await repository.reportUser(userId, reason);
  }
}
