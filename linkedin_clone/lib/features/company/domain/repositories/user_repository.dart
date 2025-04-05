import 'package:linkedin_clone/features/company/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUserFriends(String userId);
  Future<void> addAdminUser(String newUserId, String companyId);
}
