import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String? educationId; // Added ID field
  final String school;
  final String? companyLogo; // Nullable field for institution image URL
  final String companyId; // Added companyId field
  final String degree;
  final String field;
  final String startDate;
  final String? endDate; // Optional if still studying
  final String grade;
  final String description;


  const Education({
    this.educationId, // Added as optional
    required this.school,
    this.companyLogo, // Nullable
    required this.companyId, // Added as required
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
    String? companyLogo,
    String? companyId,
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
      companyLogo: companyLogo ?? this.companyLogo,
      companyId: companyId ?? this.companyId,
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
    companyLogo, 
    companyId,
    degree,
    field,
    startDate,
    endDate,
    description,
    grade,
  ];
}
