import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String title;
  final String company;
  final String location;
  final String startDate;
  final String? endDate;  // Nullable for ongoing jobs
  final String description;
  final String employmentType;
  final String locationType;
  final String? companyPicUrl; // Nullable company picture URL

  const Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate, // Nullable
    required this.description,
    required this.employmentType,
    required this.locationType,
    this.companyPicUrl, // Now nullable
  });

  @override
  List<Object?> get props => [title, company, location, startDate, endDate, description, employmentType, locationType, companyPicUrl];
}
