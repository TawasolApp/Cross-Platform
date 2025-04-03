import 'package:linkedin_clone/features/company/data/models/company_edit_model.dart';

class UpdateCompanyEntity {
  final String name;
  final bool isVerified;
  final String logo;
  final String banner;
  final String description;
  final String companySize;
  final String companyType;
  final String industry;
  final String overview;
  final String founded;
  final String website;
  final String address;
  final String location;
  final String email;
  final String contactNumber;


  UpdateCompanyEntity({
    required this.name,
    required this.isVerified,
    required this.logo,
    required this.banner,
    required this.description,
    required this.companySize,
    required this.companyType,
    required this.industry,
    required this.overview,
    required this.founded,
    required this.website,
    required this.address,
    required this.location,
    required this.email,
    required this.contactNumber,
  });

  // Method to convert UpdateCompanyDto to UpdateCompanyEntity
  factory UpdateCompanyEntity.fromDto(UpdateCompanyModel dto) {
    return UpdateCompanyEntity(
      name: dto.name,
      isVerified: dto.isVerified,
      logo: dto.logo,
      banner: dto.banner,
      description: dto.description,
      companySize: dto.companySize,
      companyType: dto.companyType,
      industry: dto.industry,
      overview: dto.overview,
      founded: dto.founded,
      website: dto.website,
      address: dto.address,
      location: dto.location,
      email: dto.email,
      contactNumber: dto.contactNumber,
    );
  }

  // Method to convert UpdateCompanyEntity to UpdateCompanyDto
  UpdateCompanyModel toDto() {
    return UpdateCompanyModel(
      name: name,
      isVerified: isVerified,
      logo: logo,
      banner:banner,
      description: description,
      companySize: companySize,
      companyType: companyType,
      industry: industry,
      overview: overview,
      founded: founded,
      website: website,
      address: address,
      location: location,
      email: email,
      contactNumber: contactNumber,
    );
  }
}
