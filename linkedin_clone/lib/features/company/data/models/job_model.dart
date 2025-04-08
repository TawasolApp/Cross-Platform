import 'package:linkedin_clone/features/company/domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.position,
    required super.company,
    required super.industry,
    required super.description,
    required super.location,
    required super.salary,
    required super.experienceLevel,
    required super.locationType,
    required super.employmentType,
    required super.postedDate,
    required super.applicantCount,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      position: json['position'],
      company: json['company'],
      industry: json['industry'],
      description: json['description'],
      location: json['location'],
      salary: (json['salary'] as num).toDouble(),
      experienceLevel: json['experienceLevel'],
      locationType: json['locationType'],
      employmentType: json['employmentType'],
      postedDate: DateTime.parse(json['postedDate']),
      applicantCount: json['applicantCount'] ?? 0, // Default to 0 if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'company': company,
      'industry': industry,
      'description': description,
      'location': location,
      'salary': salary,
      'experienceLevel': experienceLevel,
      'locationType': locationType,
      'employmentType': employmentType,
      'postedDate': postedDate.toIso8601String(),
      'applicantCount': applicantCount,
    };
  }
}
