import 'package:linkedin_clone/features/privacy/domain/repository/privacy_repository.dart';

class BlockUserUseCase {
  final PrivacyRepository repository;

  BlockUserUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.blockUser(userId);
  }
}
