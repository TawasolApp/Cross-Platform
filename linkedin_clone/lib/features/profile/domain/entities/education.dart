import 'package:equatable/equatable.dart';

class Education extends Equatable {
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

  const Education({
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
