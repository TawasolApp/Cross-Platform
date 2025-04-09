import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

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
class EducationModel extends Equatable {
  final String? educationId;
  final String school;
  final String? schoolPic;
  final String degree;
  final String field;
  final String startDate;
  final String? endDate;
  final String grade;
  final String description;

  const EducationModel({
    this.educationId,
    required this.school,
    this.schoolPic,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    required this.grade,
    required this.description,
  });

  /// Convert to Domain Entity
  Education toEntity() {
    return Education(
      educationId: educationId,
      school: school,
      schoolPic: schoolPic,
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
      schoolPic: entity.schoolPic,
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
      educationId: json['_id'] as String? ?? '',
      school: json['school'] as String,
      schoolPic: json['schoolPic'] as String?,
      degree: json['degree'] as String,
      field: json['field'] as String,
      startDate: DateUtils.formatToYearMonth(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateUtils.formatToYearMonth(json['endDate'] as String)
          : null,
      grade: json['grade'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert EducationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': educationId,
      'school': school,
      'schoolPic': schoolPic,
      'degree': degree,
      'field': field,
      'startDate': startDate,
      'endDate': endDate,
      'grade': grade,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  EducationModel copyWith({
    String? educationId,
    String? school,
    String? schoolPic,
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
      schoolPic: schoolPic ?? this.schoolPic,
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
        schoolPic,
        degree,
        field,
        startDate,
        endDate,
        grade,
        description,
      ];
}