import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';

class CreateJobModel extends CreateJobEntity {
  CreateJobModel({
    required super.position,
    required super.industry,
    required super.description,
    required super.location,
    required super.salary,
    required super.experienceLevel,
    required super.locationType,
    required super.employmentType,
  });

  // Factory method to create a model from a JSON map
  factory CreateJobModel.fromMap(Map<String, dynamic> map) {
    return CreateJobModel(
      position: map['position'],
      industry: map['industry'],
      description: map['description'],
      location: map['location'],
      salary: (map['salary'] as num).toDouble(),
      experienceLevel: map['experienceLevel'],
      locationType: map['locationType'],
      employmentType: map['employmentType'],
    );
  }

  // Convert this model into a JSON map
  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'industry': industry,
      'description': description,
      'location': location,
      'salary': salary,
      'experienceLevel': experienceLevel,
      'locationType': locationType,
      'employmentType': employmentType,
    };
  }
}
