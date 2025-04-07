import 'package:linkedin_clone/features/company/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> addAdminUser(String newUserId, String companyId);
  Future<List<User>> getCommonFollowers(String companyId);

}
