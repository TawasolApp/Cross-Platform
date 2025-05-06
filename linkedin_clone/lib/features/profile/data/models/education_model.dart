import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class DateUtils {
  static String formatToYearMonth(String dateString) {
    try {
      // Handle ISO date format
      if (dateString.contains('T')) {
        final parts = dateString.split('T')[0].split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      // Handle YYYY-MM-DD format
      else if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      // If format is unexpected, return as-is
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}

class EducationModel extends Equatable {
  final String? educationId;
  final String school;
  final String? companyLogo;
  final String? companyId;
  final String? degree;
  final String? field;
  final String? startDate;
  final String? endDate;
  final String? grade;
  final String? description;

  const EducationModel({
    this.educationId,
    required this.school,
    this.companyLogo,
    this.companyId,
    this.degree,
    this.field,
    this.startDate,
    this.endDate,
    this.grade,
    this.description,
  });

  /// Convert to Domain Entity
  Education toEntity() {
    return Education(
      educationId: educationId,
      school: school,
      companyLogo: companyLogo,
      companyId: companyId,
      degree: degree,
      field: field,
      startDate: startDate,
      endDate: endDate,
      grade: grade,
      description: description,
    );
  }

  /// Create from Domain Entity
  factory EducationModel.fromEntity(Education entity) {
    return EducationModel(
      educationId: entity.educationId,
      school: entity.school,
      companyLogo: entity.companyLogo,
      companyId: entity.companyId,
      degree: entity.degree,
      field: entity.field,
      startDate: entity.startDate,
      endDate: entity.endDate,
      grade: entity.grade,
      description: entity.description,
    );
  }

  /// Convert JSON to EducationModel
  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      educationId: json['_id'] as String?,
      school: json['school'] as String? ?? '',
      companyLogo: json['companyLogo'] as String?,
      companyId: json['companyId'] as String?,
      degree: json['degree'] as String?,
      field: json['field'] as String?,
      startDate:
          json['startDate'] != null
              ? DateUtils.formatToYearMonth(json['startDate'] as String)
              : null,
      endDate:
          json['endDate'] != null
              ? DateUtils.formatToYearMonth(json['endDate'] as String)
              : null,
      grade: json['grade'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert EducationModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'school': school};

    // Only include these fields if they're not null
    if (educationId != null && educationId!.isNotEmpty) {
      data['_id'] = educationId;
    }
    if (degree != null) {
      data['degree'] = degree;
    }
    if (field != null) {
      data['field'] = field;
    }
    if (startDate != null) {
      data['startDate'] = startDate;
    }
    if (grade != null) {
      data['grade'] = grade;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (companyLogo != null) {
      data['companyLogo'] = companyLogo;
    }
    if (companyId != null) {
      data['companyId'] = companyId;
    }
   
    data['endDate'] = endDate;


    return data;
  }

  /// Create a copy with modified fields
  EducationModel copyWith({
    String? educationId,
    String? school,
    String? companyLogo,
    String? companyId,
    String? degree,
    String? field,
    String? startDate,
    String? endDate,
    String? grade,
    String? description,
  }) {
    return EducationModel(
      educationId: educationId ?? this.educationId,
      school: school ?? this.school,
      companyLogo: companyLogo ?? this.companyLogo,
      companyId: companyId ?? this.companyId,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    educationId,
    school,
    companyLogo,
    companyId,
    degree,
    field,
    startDate,
    endDate,
    grade,
    description,
  ];
}
