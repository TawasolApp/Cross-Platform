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

  Future<List<User>> execute(String companyId) async {
    
      List<User> commonUsers= await userRepository.getCommonFollowers(companyId);
    print("Friends Following Company: ${commonUsers.map((user) => user.userId).toList()}");

    return commonUsers;
  }
}
