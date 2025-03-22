import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceModel extends Experience {
  ExperienceModel({
    required super.title,
    required super.company,
    required super.location,
    required super.startDate,
    super.endDate,
    required super.description,
    required super.employmentType,
    required super.locationType,
    super.companyPicUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'employmentType': employmentType,
      'locationType': locationType,
      'companyPicUrl': companyPicUrl,
    };
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      description: json['description'],
      employmentType: json['employmentType'],
      locationType: json['locationType'],
      companyPicUrl: json['companyPicUrl'],
    );
  }

  ExperienceModel copyWith({
    String? title,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    String? employmentType,
    String? locationType,
    String? companyPicUrl,
  }) {
    return ExperienceModel(
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      employmentType: employmentType ?? this.employmentType,
      locationType: locationType ?? this.locationType,
      companyPicUrl: companyPicUrl ?? this.companyPicUrl,
    );
  }
}
