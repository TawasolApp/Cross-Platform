import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceModel {
  final String title;
  final String company;
  final String location;
  final String startDate; // Format: "MMMM yyyy"
  final String? endDate;  // Nullable for ongoing jobs
  final String description;
  final String employmentType;
  final String locationType;
  final String? companyPicUrl; // Nullable company picture URL

  const ExperienceModel({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate, // Nullable
    required this.description,
    required this.employmentType,
    required this.locationType,
    this.companyPicUrl, // Now nullable
  });

  /// Converts JSON to ExperienceModel
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      startDate: json['startDate'], // Expecting "August 2022" format
      endDate: json['endDate'],
      description: json['description'],
      employmentType: json['employmentType'],
      locationType: json['locationType'],
      companyPicUrl: json['companyPicUrl'], // Nullable
    );
  }

  /// Converts ExperienceModel to JSON
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
      'companyPicUrl': companyPicUrl, // Nullable
    };
  }

  /// Converts ExperienceModel to Domain Entity
  Experience toEntity() {
    return Experience(
      title: title,
      company: company,
      location: location,
      startDate: startDate,
      endDate: endDate,
      description: description,
      employmentType: employmentType,
      locationType: locationType,
      companyPicUrl: companyPicUrl, // Nullable
    );
  }

  /// Converts Domain Entity to ExperienceModel
  factory ExperienceModel.fromEntity(Experience entity) {
    return ExperienceModel(
      title: entity.title,
      company: entity.company,
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      description: entity.description,
      employmentType: entity.employmentType,
      locationType: entity.locationType,
      companyPicUrl: entity.companyPicUrl, // Nullable
    );
  }
}
