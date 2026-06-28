import '../repositories/company_repository.dart';
import '../entities/company.dart';
class GetCompanyDetails {
  final CompanyRepository repository;

  GetCompanyDetails({required this.repository});

  Future<Company> execute(String companyId) async {
    return repository.getCompanyDetails(companyId);
  }
}