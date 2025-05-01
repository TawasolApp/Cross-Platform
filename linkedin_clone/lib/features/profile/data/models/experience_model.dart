import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';

class DateUtils {
  static String formatToYearMonth(String dateString) {
    try {
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}

class ExperienceModel extends Equatable {
  final String? workExperienceId;
  final String title;
  final String company;
  final String? companyLogo;
  final String? companyId;
  final String? location;
  final String startDate;
  final String? endDate;
  final String? description;
  final String employmentType;
  final String? locationType;

  const ExperienceModel({
    this.workExperienceId,
    required this.title,
    required this.company,
    this.companyLogo,
    this.companyId,
    this.location,
    required this.startDate,
    this.endDate,
    this.description,
    required this.employmentType,
    this.locationType,
  });

  // Convert to Entity
  Experience toEntity() {
    return Experience(
      workExperienceId: workExperienceId,
      title: title,
      company: company,
      companyLogo: companyLogo,
      companyId: companyId,
      location: location,
      startDate: startDate,
      endDate: endDate,
      description: description,
      employmentType: employmentType,
      locationType: locationType,
    );
  }

  // Convert from Entity
  factory ExperienceModel.fromEntity(Experience entity) {
    return ExperienceModel(
      workExperienceId: entity.workExperienceId,
      title: entity.title,
      company: entity.company,
      companyLogo: entity.companyLogo,
      companyId: entity.companyId,
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      description: entity.description,
      employmentType: entity.employmentType,
      locationType: entity.locationType,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'company': company,
      'startDate': startDate,
      'employmentType': employmentType,
    };

    // Only include fields that are not null
    if (workExperienceId != null && workExperienceId!.isNotEmpty) {
      data['_id'] = workExperienceId;
    }
    if (companyLogo != null) {
      data['companyLogo'] = companyLogo;
    }
    if (companyId != null) {
      data['companyId'] = companyId;
    }
    if (location != null) {
      data['location'] = location;
    }
    
    data['endDate'] = endDate;
    
    if (description != null) {
      data['description'] = description;
    }
    if (locationType != null) {
      data['locationType'] = locationType;
    }

    return data;
  }

  // JSON Deserialization
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      workExperienceId: json['_id'] as String?,
      title: json['title'] as String,
      company: json['company'] as String,
      companyLogo: json['companyLogo'] as String?,
      companyId: json['companyId'] as String?,
      location: json['location'] as String?,
      startDate: DateUtils.formatToYearMonth(json['startDate'] as String),
      endDate:
          json['endDate'] != null
              ? DateUtils.formatToYearMonth(json['endDate'] as String)
              : null,
      description: json['description'] as String?,
      employmentType: json['employmentType'] as String,
      locationType: json['locationType'] as String?,
    );
  }

  // Copy with method
  ExperienceModel copyWith({
    String? workExperienceId,
    String? title,
    String? company,
    String? companyLogo,
    String? companyId,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    String? employmentType,
    String? locationType,
  }) {
    return ExperienceModel(
      workExperienceId: workExperienceId ?? this.workExperienceId,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      companyId: companyId ?? this.companyId,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      employmentType: employmentType ?? this.employmentType,
      locationType: locationType ?? this.locationType,
    );
  }

  @override
  List<Object?> get props => [
    workExperienceId,
    title,
    company,
    companyLogo,
    companyId,
    location,
    startDate,
    endDate,
    description,
    employmentType,
    locationType,
  ];
}
