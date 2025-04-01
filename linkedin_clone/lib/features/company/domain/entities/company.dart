class Company {
  final String companyId;
  final String name;
  final String industry;
  final String companySize;
  final String companyType;
  
  final bool? isFollowing;
  final bool? isVerified;
  final String? logo;
  final String? description;
  final int? followers;
  final String? overview;
  final String? founded;
  final String? website;
  final String? address;
  final String? location;
  final String? email;
  final String? contactNumber;
  final String? banner;
  final String? specialities;

  const Company({
    required this.companyId,
    required this.name,
    required this.industry,
    required this.companySize,
    required this.companyType,
    this.isFollowing,
    this.isVerified,
    this.logo,
    this.description,
    this.followers,
    this.overview,
    this.founded,
    this.website,
    this.address,
    this.location,
    this.email,
    this.contactNumber,
    this.banner,
    this.specialities,
  });
}
