import '../repositories/admin_repository.dart';

class ResolveReportUseCase {
  final AdminRepository repository;

  ResolveReportUseCase(this.repository);

  Future<void> call({
    required String reportId,
    required String action, // delete_post, suspend_user, ignore
    String? comment,
  }) {
    return repository.resolveReport(reportId, action, comment);
  }
}
