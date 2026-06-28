class CompanyCreateEntity {
  final String name;
  final String industry;
  final String companySize;
  final String companyType;

  final String? logo;
  final String? banner;
  final String? description;
  final String? overview;
  final int? founded;
  final String? website;
  final String? address;
  final String? location;
  final String? email;
  final String? contactNumber;

  CompanyCreateEntity({
    required this.name,
    required this.industry,
    required this.companySize,
    required this.companyType,
    this.logo,
    this.banner,
    this.description,
    this.overview,
    this.founded,
    this.website,
    this.address,
    this.location,
    this.email,
    this.contactNumber,
  });
}