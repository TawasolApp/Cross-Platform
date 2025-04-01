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
      companyId: json['id'],
      name: json['name'],
      industry: json['industry'],
      companySize: json['companySize'],
      companyType: json['companyType'],
      isFollowing: json['isFollowing'],
      isVerified: json['isVerified'],
      logo: json['logo'],
      description: json['description'],
      followers: json['followers'],
      overview: json['overview'],
      founded: json['founded'],
      website: json['website'],
      address: json['address'],
      location: json['location'],
      email: json['email'],
      contactNumber: json['contactNumber']?.toString(), // Ensure it's a String
      banner: json['banner'],
      specialities: json['specialities'],
    );
  }

  // ✅ Convert CompanyModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': companyId,
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
    };
  }
}
