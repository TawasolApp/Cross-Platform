import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../repositories/company_repository.dart';

class GetFriendsFollowingCompany {
  final UserRepository userRepository;
  final CompanyRepository companyRepository;

  GetFriendsFollowingCompany({
    required this.userRepository,
    required this.companyRepository,
  });

  Future<List<User>> execute(String userId, String companyId) async {
    // Fetch the user's friends
    final userFriends = await userRepository.getUserFriends(userId);
    print("User Friends: ${userFriends.map((user) => user.userId).toList()}");

    // Fetch the company's followers
    final companyFollowers = await companyRepository.getCompanyFollowers(companyId);
    print("Company Followers: ${companyFollowers.map((user) => user.userId).toList()}");

    // Find common users (friends who follow the company)
    final commonUsers = userFriends.where(
      (friend) => companyFollowers.any((f) => f.userId == friend.userId),
    ).toList();

    print("Friends Following Company: ${commonUsers.map((user) => user.userId).toList()}");

    return commonUsers;
  }
}
