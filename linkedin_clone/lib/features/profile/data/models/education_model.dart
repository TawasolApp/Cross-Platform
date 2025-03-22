import 'package:linkedin_clone/features/profile/domain/entities/education.dart';

class EducationModel extends Education {
  EducationModel({
    required super.school,
    super.schoolPic,
    required super.degree,
    required super.field,
    required super.startDate,
    super.endDate,
    required super.grade,
    required super.description,
  });

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
}