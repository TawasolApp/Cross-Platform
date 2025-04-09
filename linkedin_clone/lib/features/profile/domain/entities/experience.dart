import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String? workExperienceId; // Added ID field
  final String title;
  final String company;
  final String? location;
  final String startDate;
  final String? endDate; // Nullable for ongoing jobs
  final String? description;
  final String employmentType;
  final String? locationType;
  final String? workExperiencePicture; // Nullable company picture URL

  const Experience({
    this.workExperienceId, // Added as optional
    required this.title,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate, // Nullable
     this.description,
    required this.employmentType,
    this.locationType,
    this.workExperiencePicture, // Now nullable
  });

  Experience copyWith({
    String? workExperienceId,
    String? title,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    String? employmentType,
    String? locationType,
    String? workExperiencePicture,
  }) {
    return Experience(
      workExperienceId: workExperienceId ?? this.workExperienceId,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      employmentType: employmentType ?? this.employmentType,
      locationType: locationType ?? this.locationType,
      workExperiencePicture: workExperiencePicture ?? this.workExperiencePicture,
    );
  }

  @override
  List<Object?> get props => [
    workExperienceId,
    title,
    company,
    location,
    startDate,
    endDate,
    description,
    employmentType,
    locationType,
    workExperiencePicture,
  ];
}
