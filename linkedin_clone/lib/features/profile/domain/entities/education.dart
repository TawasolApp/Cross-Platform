import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String? educationId; // Added ID field
  final String school;
  final String? schoolPic; // Nullable field for institution image URL
  final String degree;
  final String field;
  final String startDate;
  final String? endDate; // Optional if still studying
  final String grade;
  final String description;


  const Education({
    this.educationId, // Added as optional
    required this.school,
    this.schoolPic, // Nullable
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate, // Nullable
    required this.grade,
    required this.description,
  });

  Education copyWith({
    String? educationId,
    String? school,
    String? schoolPic,
    String? degree,
    String? field,
    String? startDate,
    String? endDate,
    String? description,
    String? grade,
  }) {
    return Education(
      educationId: educationId ?? this.educationId,
      school: school ?? this.school,
      schoolPic: schoolPic ?? this.schoolPic,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      grade: grade ?? this.grade,
    );
  }

  @override
  List<Object?> get props => [
    educationId,
    school,
    schoolPic, // Include in props for comparison
    degree,
    field,
    startDate,
    endDate,
    description,
    grade,
  ];
}
