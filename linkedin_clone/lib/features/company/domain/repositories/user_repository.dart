import 'package:linkedin_clone/features/company/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUserFriends(String userId);
  Future<bool> checkIfUserFollowsCompany(String userId, String companyId);
  Future<void> addAdminUser(String newUserId);
}
