// UpdateCompanyModel.dart

import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';

class UpdateCompanyModel extends UpdateCompanyEntity {
  UpdateCompanyModel({
    required String name,
    required bool isVerified,
    required String logo,
    required String banner,
    required String description,
    required String companySize,
    required String companyType,
    required String industry,
    required String overview,
    required String founded,
    required String website,
    required String address,
    required String location,
    required String email,
    required String contactNumber,
  }) : super(
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

  // Factory constructor to create an UpdateCompanyModel instance from a JSON map
  factory UpdateCompanyModel.fromJson(Map<String, dynamic> json) {
    return UpdateCompanyModel(
      name: json['name'],
      isVerified: json['isVerified'],
      logo: json['logo'],
      banner:json['banner'],
      description: json['description'],
      companySize: json['companySize'],
      companyType: json['companyType'],
      industry: json['industry'],
      overview: json['overview'],
      founded: json['founded'],
      website: json['website'],
      address: json['address'],
      location: json['location'],
      email: json['email'],
      contactNumber: json['contactNumber'],
    );
  }

  // Method to convert the model to a Map (used for sending data to an API)
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isVerified': isVerified,
      'logo': logo,
      'banner':banner,
      'description': description,
      'companySize': companySize,
      'companyType': companyType,
      'industry': industry,
      'overview': overview,
      'founded': founded,
      'website': website,
      'address': address,
      'location': location,
      'email': email,
      'contactNumber': contactNumber,
    };
  }
}
