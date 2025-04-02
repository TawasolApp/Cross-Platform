import '../../domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required String companyId,
    required String name,
    required String industry,
    required String companySize,
    required String companyType,
    bool? isFollowing,
    bool? isVerified,
    bool? isAdmin,
    String? logo,
    String? description,
    int? followers,
    String? overview,
    String? founded,
    String? website,
    String? address,
    String? location,
    String? email,
    String? contactNumber,
    String? banner,
    String? specialities,
  }) : super(
         companyId: companyId,
         name: name,
         industry: industry,
         companySize: companySize,
         companyType: companyType,
         isFollowing: isFollowing,
         isVerified: isVerified,
         isAdmin: isAdmin,
         logo: logo,
         description: description,
         followers: followers,
         overview: overview,
         founded: founded,
         website: website,
         address: address,
         location: location,
         email: email,
         contactNumber: contactNumber,
         banner: banner,
         specialities: specialities,
       );

  // ✅ Convert JSON to CompanyModel
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['companyId'] ?? '', // Use an empty string if null
      name: json['name'] ?? '', // Use an empty string if null
      industry: json['industry'] ?? '', // Use an empty string if null
      companySize: json['companySize'] ?? '', // Use an empty string if null
      companyType: json['companyType'] ?? '', // Use an empty string if null
      isFollowing: json['isFollowing'] ?? false, // Default to false if null
      isVerified: json['isVerified'] ?? false, // Default to false if null
      logo: json['logo'] ?? '', // Default to an empty string if null
      description:
          json['description'] ?? '', // Default to an empty string if null
      followers: json['followers'] ?? 0, // Default to 0 if null
      overview: json['overview'] ?? '', // Default to an empty string if null
      founded: json['founded'] ?? '', // Default to an empty string if null
      website: json['website'] ?? '', // Default to an empty string if null
      address: json['address'] ?? '', // Default to an empty string if null
      location: json['location'] ?? '', // Default to an empty string if null
      email: json['email'] ?? '', // Default to an empty string if null
      contactNumber:
          json['contactNumber']?.toString() ??
          '', // Ensure it's a String, default to empty if null
      banner: json['banner'] ?? '', // Default to an empty string if null
      specialities:
          json['specialities'] ?? '', // Default to an empty string if null
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  // ✅ Convert CompanyModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'name': name,
      'industry': industry,
      'companySize': companySize,
      'companyType': companyType,
      'isFollowing': isFollowing,
      'isVerified': isVerified,
      'logo': logo,
      'description': description,
      'followers': followers,
      'overview': overview,
      'founded': founded,
      'website': website,
      'address': address,
      'location': location,
      'email': email,
      'contactNumber': contactNumber,
      'banner': banner,
      'specialities': specialities,
      'isAdmin': isAdmin,
    };
  }
}
