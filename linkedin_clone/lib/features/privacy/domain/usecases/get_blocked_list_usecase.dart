import 'package:linkedin_clone/features/privacy/domain/entities/privacy_user_entity.dart';
import 'package:linkedin_clone/features/privacy/domain/repository/privacy_repository.dart';

class GetBlockedListUseCase {
  final PrivacyRepository repository;

  GetBlockedListUseCase(this.repository);

  Future<List<PrivacyUserEntity>> call({int page = 0, int limit = 0}) async {
    try {
      return await repository.getBlockedList();
    } catch (e) {
      rethrow;
    }
  }
}
