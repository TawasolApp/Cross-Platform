import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class EducationModel extends Equatable {
  final String school;
  final String? schoolPic;
  final String degree;
  final String field;
  final String startDate;
  final String? endDate;
  final String grade;
  final String description;

  const EducationModel({
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
      school: json['school'] as String,
      schoolPic: json['schoolPic'] as String?,
      degree: json['degree'] as String,
      field: json['field'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      grade: json['grade'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert EducationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'school': school,
      'schoolPic': schoolPic,
      'degree': degree,
      'field': field,
      'start_date': startDate,
      'end_date': endDate,
      'grade': grade,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  EducationModel copyWith({
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