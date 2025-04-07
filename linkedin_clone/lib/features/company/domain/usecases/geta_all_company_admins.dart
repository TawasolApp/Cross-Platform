import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';

class FetchCompanyAdminsUseCase {
  final CompanyRepository companyRepository;

  FetchCompanyAdminsUseCase({required this.companyRepository});

  Future<List<User>> execute (String companyId) async {
    print('HHIIIIIIIIIIIIIIIIIIII');
    return await companyRepository.getCompanyAdmins(companyId);
  }
}
