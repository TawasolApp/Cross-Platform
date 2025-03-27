import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';
import 'package:linkedin_clone/features/company/data/models/company_model.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import '../../domain/entities/user.dart';
class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Company> getCompanyDetails(String companyId) async {
        // TODO: Implement error handling for API call failures.
    final companyModel = await remoteDataSource.getCompanyDetails(companyId);
    return CompanyModel(
      id: companyModel.id,
      name: companyModel.name,
      description: companyModel.description,
      website: companyModel.website,
      bannerUrl: companyModel.bannerUrl,
      logoUrl: companyModel.logoUrl,
      field: companyModel.field,
      followerCount: companyModel.followerCount,
      employeeCount: companyModel.employeeCount,
      location: companyModel.location,
      followerIds: companyModel.followerIds,
    );
  }
    @override
  Future<List<User>> getCompanyFollowers(String companyId) async {
        // TODO: Implement error handling for API call failures.

    return await remoteDataSource.fetchCompanyFollowers(companyId);
  }
  
  @override
  Future<List<Company>> getRelatedCompanies(String companyId) async {
// TODO: Implement error handling for API call failures.

    final relatedCompaniesModel = await remoteDataSource.getRelatedCompanies(companyId);
    return relatedCompaniesModel.map((companyModel) => CompanyModel(
      id: companyModel.id,
      name: companyModel.name,
      description: companyModel.description,
      website: companyModel.website,
      bannerUrl: companyModel.bannerUrl,
      logoUrl: companyModel.logoUrl,
      field: companyModel.field,
      followerCount: companyModel.followerCount,
      employeeCount: companyModel.employeeCount,
      location: companyModel.location,
      followerIds: companyModel.followerIds,
    )).toList();
  }
    @override
      Future<void> createCompany(Company company) async {
    await remoteDataSource.createCompany(company);
  }
}