import 'package:linkedin_clone/features/company/domain/entities/company.dart';
class CompanyModel extends Company {
  CompanyModel({
    required super.id,
    required super.name,
    required super.description,
    required super.website,
    required super.bannerUrl,
    required super.logoUrl,
    required super.field,
    required super.followerCount,
    required super.employeeCount,
    required super.location,
    required super.followerIds,

  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      website: json['website'],
      bannerUrl: json['bannerUrl'],
      logoUrl: json['logoUrl'],
      field: json['field'],
      followerCount: json['followerCount'],
      employeeCount: json['employeeCount'],
      location: json['location'],
    followerIds: (json['followerIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}