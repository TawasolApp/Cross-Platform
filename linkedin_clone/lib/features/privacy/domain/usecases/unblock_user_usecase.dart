import 'package:linkedin_clone/features/privacy/domain/repository/privacy_repository.dart';

class UnblockUserUseCase {
  final PrivacyRepository repository;

  UnblockUserUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.unblockUser(userId);
  }
}
