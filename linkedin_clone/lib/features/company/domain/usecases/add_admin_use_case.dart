import '../repositories/user_repository.dart';

class AddAdminUseCase {
  final UserRepository repository;

  AddAdminUseCase({required this.repository});
  Future<void> call(String newUserId,String companyId) async {
    await repository.addAdminUser(newUserId,companyId);
  }
}