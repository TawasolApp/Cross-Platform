import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';
class UpdateCompanyDetails {
  final CompanyRepository companyRepository;

  UpdateCompanyDetails({required this.companyRepository});

  Future<void> execute(UpdateCompanyEntity updatedCompany) async {
    await companyRepository.updateCompanyDetails(updatedCompany);
  }
}
