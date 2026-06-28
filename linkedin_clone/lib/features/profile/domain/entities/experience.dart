import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String? workExperienceId;
  final String title;
  final String company;
  final String? companyLogo; // Added to match model
  final String? companyId; // Added to match model
  final String? location;
  final String startDate;
  final String? endDate;
  final String? description;
  final String employmentType;
  final String? locationType;

  const Experience({
    this.workExperienceId,
    required this.title,
    required this.company,
    this.companyLogo, // Added parameter
    this.companyId, // Added parameter
    this.location,
    required this.startDate,
    this.endDate,
    this.description,
    required this.employmentType,
    this.locationType,
  });

  Experience copyWith({
    String? workExperienceId,
    String? title,
    String? company,
    String? companyLogo, // Added parameter
    String? companyId, // Added parameter
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    String? employmentType,
    String? locationType,
  }) {
    return Experience(
      workExperienceId: workExperienceId ?? this.workExperienceId,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo, // Added field
      companyId: companyId ?? this.companyId, // Added field
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
    companyLogo, // Added field
    companyId, // Added field
    location,
    startDate,
    endDate,
    description,
    employmentType,
    locationType,
  ];
}
