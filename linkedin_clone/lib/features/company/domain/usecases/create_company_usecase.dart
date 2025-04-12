import 'package:linkedin_clone/features/company/domain/entities/company_create_entity.dart';

import '../repositories/company_repository.dart';

class CreateCompanyUseCase {
  final CompanyRepository repository;

  CreateCompanyUseCase(this.repository);

  Future<void> call(CompanyCreateEntity company) async {
    if (company.name.isEmpty || company.website!.isEmpty) {
      throw Exception("Company name and URL are required.");
    }
    await repository.createCompany(company);
  }
}
