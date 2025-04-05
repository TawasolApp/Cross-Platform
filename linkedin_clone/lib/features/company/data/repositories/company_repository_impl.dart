import 'package:linkedin_clone/features/company/data/models/company_create_model.dart';
import 'package:linkedin_clone/features/company/data/models/company_edit_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_create_entity.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
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
      isManager: companyModel.isManager,
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
    final relatedCompaniesModel = await remoteDataSource.getRelatedCompanies(
      companyId,
    );
    return relatedCompaniesModel
        .map(
          (companyModel) => Company(
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
          ),
        )
        .toList();
  }

  @override
  Future<void> createCompany(CompanyCreateEntity company) async {
    await remoteDataSource.createCompany(company as CompanyCreateModel );
  }
  @override
  Future<void> updateCompanyDetails(UpdateCompanyEntity updatedCompany,String companyId) async {
    await remoteDataSource.updateCompanyDetails(
      UpdateCompanyModel(
        name: updatedCompany.name,
        description: updatedCompany.description,
        website: updatedCompany.website,
        logo: updatedCompany.logo,
        banner:updatedCompany.banner,
        industry: updatedCompany.industry,
        companySize: updatedCompany.companySize,
        location: updatedCompany.location,
        overview: updatedCompany.overview,
        founded: updatedCompany.founded,
        address: updatedCompany.address,
        email: updatedCompany.email,
        contactNumber: updatedCompany.contactNumber,
        isVerified: updatedCompany.isVerified,
        companyType: updatedCompany.companyType,
      ),companyId,
    );
  }
 @override
  Future<List<Company>> getAllCompanies() {
    print('helllooo');
    return remoteDataSource.getAllCompanies();
  }

}
