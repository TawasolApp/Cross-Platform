import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';

class GetAllCompaniesUseCase {
  final CompanyRepository repository;

  GetAllCompaniesUseCase({required this.repository});

  Future<List<Company>> execute(String query, {int page = 1, int limit = 10}) {
    print("🤩🤩🤩🤩GetAllCompaniesUseCase: $query, page: $page, limit: $limit");
    return repository.getAllCompanies(query, page: page, limit: limit);
  }
}
