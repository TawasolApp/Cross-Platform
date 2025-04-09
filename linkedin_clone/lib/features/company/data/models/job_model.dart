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
    required bool isOpen,
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
         isOpen: isOpen,
       );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id:
          json['jobId'] ??
          json['id'] ??
          '', // Handle both 'jobId' and 'id' keys
      position: json['position'] ?? '', // Default to empty string if missing
      company: json['companyId'] ?? '', // Default to empty string if missing
      industry: json['industry'] ?? '', // Default to empty string if missing
      description:
          json['description'] ?? '', // Default to empty string if missing
      location: json['location'] ?? '', // Default to empty string if missing
      salary: (json['salary'] ?? 0).toDouble(),
      experienceLevel:
          json['experienceLevel'] ?? '', // Default to empty string if missing
      locationType:
          json['locationType'] ?? '', // Default to empty string if missing
      employmentType:
          json['employmentType'] ?? '', // Default to empty string if missing
      postedDate:
          DateTime.parse(json['postedAt']) ??
          DateTime.now(), // Default to current date if missing
      applicantCount: json['applicants'] ?? 0, // Default to 0 if missing
      isOpen: json['isOpen'] ?? true, // Default to true if missing
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
      'isOpen': isOpen,
    };
  }
}
