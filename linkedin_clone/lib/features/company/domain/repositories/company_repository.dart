import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';

import '../entities/company.dart';
import '../entities/user.dart'; 
abstract class CompanyRepository {
  Future<Company> getCompanyDetails(String companyId);
    Future<List<User>> getCompanyFollowers(String companyId); 
  Future<List<Company>> getRelatedCompanies(String companyId);
    Future<void> createCompany(Company company);
      Future<void> updateCompanyDetails(UpdateCompanyEntity updatedcompany);
}