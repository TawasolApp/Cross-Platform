import 'package:linkedin_clone/features/company/domain/entities/company_create_entity.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';

import '../entities/company.dart';
import '../entities/user.dart';

abstract class CompanyRepository {
  Future<Company> getCompanyDetails(String companyId);
  Future<List<Company>> getRelatedCompanies(String companyId,{int page = 1, int limit = 10});
  Future<void> createCompany(CompanyCreateEntity company);
  Future<void> updateCompanyDetails(
    UpdateCompanyEntity updatedcompany,
    String companyId,
  );
Future<List<Company>> getAllCompanies(String query, {int page = 1, int limit = 4});
  Future<List<User>> getCompanyAdmins(String companyId);
  Future<List<User>> getFollowers(String companyId);
}
