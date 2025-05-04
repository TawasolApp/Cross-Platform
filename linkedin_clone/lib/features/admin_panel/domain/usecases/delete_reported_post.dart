import 'package:linkedin_clone/features/admin_panel/domain/repositories/admin_repository.dart';

class DeleteReportedPostUseCase {
  final AdminRepository repository;

  DeleteReportedPostUseCase(this.repository);

  Future<void> call({required String companyId, required String postId}) {
    return repository.deleteReportedPost(companyId, postId);
  }
}
