import 'package:linkedin_clone/features/privacy/domain/repository/privacy_repository.dart';

class ReportPostUseCase {
  final PrivacyRepository repository;

  ReportPostUseCase(this.repository);

  Future<bool> call(String postId, String reason) async {
    return await repository.reportPost(postId, reason);
  }
}
