import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class DateUtils {
  static String formatToYearMonth(String dateString) {
    try {
      // Handle various date formats that might come from API
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      // If format is unexpected, return as-is (you might want to throw an error instead)
      return dateString;
    } catch (e) {
      return dateString; // or throw FormatException('Invalid date format');
    }
  }
}
class ExperienceModel {
  final String? workExperienceId;
  final String title;
  final String company;
  final String? location;
  final String startDate;
  final String? endDate;
  final String? description;
  final String employmentType;
  final String? locationType;
  final String? workExperiencePicture;

  const ExperienceModel({
    this.workExperienceId,
    required this.title,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate,
    this.description,
    required this.employmentType,
    this.locationType,
    this.workExperiencePicture,
  });

  // Convert to Entity
  Experience toEntity() {
    return Experience(
      workExperienceId: workExperienceId,
      title: title,
      company: company,
      location: location,
      startDate: startDate,
      endDate: endDate,
      description: description,
      employmentType: employmentType,
      locationType: locationType,
      workExperiencePicture: workExperiencePicture,
    );
  }

  // Convert from Entity
  factory ExperienceModel.fromEntity(Experience entity) {
    return ExperienceModel(
      workExperienceId: entity.workExperienceId,
      title: entity.title,
      company: entity.company,
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      description: entity.description,
      employmentType: entity.employmentType,
      locationType: entity.locationType,
      workExperiencePicture: entity.workExperiencePicture,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      '_id': workExperienceId,
      'title': title,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'employmentType': employmentType,
      'locationType': locationType,
      'workExperiencePicture': workExperiencePicture,
    };
  }

  // JSON Deserialization
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      workExperienceId: json['_id'] as String? ?? '',
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String?,
      startDate: DateUtils.formatToYearMonth(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateUtils.formatToYearMonth(json['endDate'] as String)
          : null,
      description: json['description'] as String?,
      employmentType: json['employmentType'] as String,
      locationType: json['locationType'] as String?,
      workExperiencePicture: json['workExperiencePicture'] as String?,
    );
  }

  // Copy with method
  ExperienceModel copyWith({
    String? workExperienceId,
    String? title,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    String? employmentType,
    String? locationType,
    String? workExperiencePicture,
  }) {
    return ExperienceModel(
      workExperienceId: workExperienceId ?? this.workExperienceId,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      employmentType: employmentType ?? this.employmentType,
      locationType: locationType ?? this.locationType,
      workExperiencePicture: workExperiencePicture ?? this.workExperiencePicture,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceModel &&
          runtimeType == other.runtimeType &&
          workExperienceId == other.workExperienceId &&
          title == other.title &&
          company == other.company &&
          location == other.location &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          description == other.description &&
          employmentType == other.employmentType &&
          locationType == other.locationType &&
          workExperiencePicture == other.workExperiencePicture;

  @override
  int get hashCode =>
      workExperienceId.hashCode ^
      title.hashCode ^
      company.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      description.hashCode ^
      employmentType.hashCode ^
      locationType.hashCode ^
      workExperiencePicture.hashCode;
}