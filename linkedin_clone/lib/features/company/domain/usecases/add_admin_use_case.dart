import '../repositories/user_repository.dart';

class AddAdminUseCase {
  final UserRepository repository;

  AddAdminUseCase({required this.repository});
//TODO:Add validation if user not found
  Future<void> call(String newUserId,String companyId) async {
    await repository.addAdminUser(newUserId,companyId);
  }
}