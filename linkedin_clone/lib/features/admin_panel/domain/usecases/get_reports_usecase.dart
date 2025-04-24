import '../repositories/admin_repository.dart';
import '../entities/report_entity.dart';

class GetReportsUseCase {
  final AdminRepository repository;

  GetReportsUseCase(this.repository);

  Future<List<ReportEntity>> call({String? status, String? type}) {
    return repository.getReports(status: status, type: type);
  }
}
