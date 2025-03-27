import '../repositories/company_repository.dart';
import '../entities/company.dart';
class GetRelatedCompanies {
  final CompanyRepository repository;

  GetRelatedCompanies({required this.repository});

  Future<List<Company>> execute(String companyId) async {
    return repository.getRelatedCompanies(companyId);
  }
}