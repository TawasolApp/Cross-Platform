import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class EducationModel extends Equatable {
  final String institution;
  final String? institutionPic; // New field for institution image URL
  final String degree;
  final String field;
  final String startDate;
  final String? endDate; // Optional if still studying
  final String description;
  final String grade;

  const EducationModel({
    required this.institution,
    this.institutionPic, // Added here
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate, // Nullable
    required this.description,
    required this.grade,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      institution: json['institution'] as String,
      institutionPic: json['institutionPic'] as String, // Deserialize institutionPic
      degree: json['degree'] as String,
      field: json['field'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      description: json['description'] as String,
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'institutionPic': institutionPic, // Serialize institutionPic
      'degree': degree,
      'field': field,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'grade': grade,
    };
  }

  /// Converts `EducationModel` to `Education` entity
  Education toEntity() {
    return Education(
      institution: institution,
      institutionPic: institutionPic, // Pass institutionPic to entity
      degree: degree,
      field: field,
      startDate: startDate,
      endDate: endDate,
      description: description,
      grade: grade,
    );
  }

  /// Creates `EducationModel` from `Education` entity
  factory EducationModel.fromEntity(Education entity) {
    return EducationModel(
      institution: entity.institution,
      institutionPic: entity.institutionPic, // Extract from entity
      degree: entity.degree,
      field: entity.field,
      startDate: entity.startDate,
      endDate: entity.endDate,
      description: entity.description,
      grade: entity.grade,
    );
  }

  @override
  List<Object?> get props => [
        institution,
        institutionPic, // Include in props for comparison
        degree,
        field,
        startDate,
        endDate,
        description,
        grade,
      ];
}
