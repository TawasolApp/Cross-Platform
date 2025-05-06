import 'package:linkedin_clone/features/company/domain/entities/company_create_entity.dart';

class CompanyCreateModel extends CompanyCreateEntity {
  CompanyCreateModel({
    required String name,
    required String companySize,
    required String companyType,
    required String industry,
    String? logo,
    String? banner,
    String? description,
    String? overview,
    int? founded,
    String? website,
    String? address,
    String? location,
    String? email,
    String? contactNumber,
  }) : super(
         name: name,
         companySize: companySize,
         companyType: companyType,
         industry: industry,
         logo: logo,
         banner: banner,
         description: description,
         overview: overview,
         founded: founded,
         website: website,
         address: address,
         location: location,
         email: email,
         contactNumber: contactNumber,
       );

  factory CompanyCreateModel.fromJson(Map<String, dynamic> json) {
    return CompanyCreateModel(
      name: json['name'],
      companySize: json['companySize'],
      companyType: json['companyType'],
      industry: json['industry'],
      logo: json['logo'],
      banner: json['banner'],
      description: json['description'],
      overview: json['overview'],
      founded: json['founded'],
      website: json['website'],
      address: json['address'],
      location: json['location'],
      email: json['email'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    bool isValid(String? value) => value != null && value.trim().isNotEmpty;

    final Map<String, dynamic> data = {
      'name': name,
      'companySize': companySize,
      'companyType': companyType,
      'industry': industry,
    };

    if (isValid(logo)) data['logo'] = logo;
    if (isValid(banner)) data['banner'] = banner;
    if (isValid(description)) data['description'] = description;
    if (isValid(overview)) data['overview'] = overview;
    if (founded != null && founded! > 1800) data['founded'] = founded;
    if (isValid(website)) data['website'] = website;
    if (isValid(address)) data['address'] = address;
    if (isValid(location)) data['location'] = location;
    if (isValid(email)) data['email'] = email;
    if (isValid(contactNumber)) data['contactNumber'] = contactNumber;

    return data;
  }
}
