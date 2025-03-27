import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class ExperienceModel {
  final String title;
  final String company;
  final String location;
  final String startDate;
  final String? endDate;
  final String description;
  final String employmentType;
  final String locationType;
  final String? companyPicUrl;

  const ExperienceModel({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.employmentType,
    required this.locationType,
    this.companyPicUrl,
  });

  // Convert to Entity
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
      companyPicUrl: companyPicUrl,
    );
  }

  // Convert from Entity
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
      companyPicUrl: entity.companyPicUrl,
    );
  }

  // JSON Serialization
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

  // JSON Deserialization
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      description: json['description'] as String,
      employmentType: json['employmentType'] as String,
      locationType: json['locationType'] as String,
      companyPicUrl: json['companyPicUrl'] as String?,
    );
  }

  // Copy with method
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          company == other.company &&
          location == other.location &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          description == other.description &&
          employmentType == other.employmentType &&
          locationType == other.locationType &&
          companyPicUrl == other.companyPicUrl;

  @override
  int get hashCode =>
      title.hashCode ^
      company.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      description.hashCode ^
      employmentType.hashCode ^
      locationType.hashCode ^
      companyPicUrl.hashCode;
}