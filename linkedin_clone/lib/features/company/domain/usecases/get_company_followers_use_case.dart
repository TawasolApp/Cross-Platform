
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';

class GetCompanyFollowersUseCase {
  final CompanyRepository repository;

  GetCompanyFollowersUseCase({required this.repository});

  Future<List<User>> execute(String companyId) {
    return repository.getFollowers(companyId);
  }
}
