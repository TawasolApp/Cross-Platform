import '../entities/reported_post_entity.dart';
import '../repositories/admin_repository.dart';

class FetchReportedPosts {
  final AdminRepository repository;

  FetchReportedPosts(this.repository);

  Future<List<ReportedPost>> call({String? status}) {
    return repository.fetchReportedPosts(status: status);
  }
}
