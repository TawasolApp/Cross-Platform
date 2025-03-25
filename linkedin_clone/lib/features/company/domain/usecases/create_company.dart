import '../entities/company.dart';
import '../repositories/company_repository.dart';

class CreateCompanyUseCase {
  final CompanyRepository repository;

  CreateCompanyUseCase(this.repository);

  Future<void> call(Company company) async {
    if (company.name.isEmpty || company.website.isEmpty) {
      throw Exception("Company name and URL are required.");
    }
    await repository.createCompany(company);
  }
}
