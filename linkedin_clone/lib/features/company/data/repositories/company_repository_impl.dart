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
    return Company(
      companyId: companyModel.companyId,
      name: companyModel.name,
      description: companyModel.description,
      website: companyModel.website,
      banner: companyModel.banner,
      logo: companyModel.logo,
      industry: companyModel.industry,
      followers: companyModel.followers,
      companySize: companyModel.companySize,
      location: companyModel.location,
      isFollowing: companyModel.isFollowing,
      isVerified: companyModel.isVerified,
      companyType: companyModel.companyType,
      overview: companyModel.overview,
      founded: companyModel.founded,
      address: companyModel.address,
      email: companyModel.email,
      contactNumber: companyModel.contactNumber,
      specialities: companyModel.specialities,
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
    return relatedCompaniesModel.map((companyModel) => Company(
      companyId: companyModel.companyId,
      name: companyModel.name,
      description: companyModel.description,
      website: companyModel.website,
      banner: companyModel.banner,
      logo: companyModel.logo,
      industry: companyModel.industry,
      followers: companyModel.followers,
      companySize: companyModel.companySize,
      location: companyModel.location,
      isFollowing: companyModel.isFollowing,
      isVerified: companyModel.isVerified,
      companyType: companyModel.companyType,
      overview: companyModel.overview,
      founded: companyModel.founded,
      address: companyModel.address,
      email: companyModel.email,
      contactNumber: companyModel.contactNumber,
      specialities: companyModel.specialities,
    )).toList();
  }

  @override
  Future<void> createCompany(Company company) async {
    await remoteDataSource.createCompany(CompanyModel(
      companyId: company.companyId,
      name: company.name,
      description: company.description,
      website: company.website,
      banner: company.banner,
      logo: company.logo,
      industry: company.industry,
      followers: company.followers,
      companySize: company.companySize,
      location: company.location,
      isFollowing: company.isFollowing,
      isVerified: company.isVerified,
      companyType: company.companyType,
      overview: company.overview,
      founded: company.founded,
      address: company.address,
      email: company.email,
      contactNumber: company.contactNumber,
      specialities: company.specialities,
    ));
  }
}
