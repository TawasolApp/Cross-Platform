import '../repositories/company_repository.dart';
import '../entities/company.dart';
class GetRelatedCompanies {
  final CompanyRepository repository;

  GetRelatedCompanies({required this.repository});

  Future<List<Company>> execute(String companyId , {int page = 1, int limit = 4}) async {
    return repository.getRelatedCompanies(companyId,page: page, limit: limit);
  }
}