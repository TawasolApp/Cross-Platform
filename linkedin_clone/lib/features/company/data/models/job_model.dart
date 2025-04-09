import 'package:linkedin_clone/features/company/domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required String id,
    required String position,
    required String company,
    required String industry,
    required String description,
    required String location,
    required double salary,
    required String experienceLevel,
    required String locationType,
    required String employmentType,
    required DateTime postedDate,
    required int applicantCount,
  }) : super(
          id: id,
          position: position,
          company: company,
          industry: industry,
          description: description,
          location: location,
          salary: salary,
          experienceLevel: experienceLevel,
          locationType: locationType,
          employmentType: employmentType,
          postedDate: postedDate,
          applicantCount: applicantCount,
        );

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
