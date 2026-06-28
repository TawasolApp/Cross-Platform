import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';

class CreateJobModel extends CreateJobEntity {
  CreateJobModel({
    required String position,
    required String industry,
    required String description,
    required String location,
    required double salary,
    required String experienceLevel,
    required String locationType,
    required String employmentType,
  }) : super(
         position: position,
         industry: industry,
         description: description,
         location: location,
         salary: salary,
         experienceLevel: experienceLevel,
         locationType: locationType,
         employmentType: employmentType,
       );

  // Factory method to create a model from a JSON map
  factory CreateJobModel.fromJson(Map<String, dynamic> map) {
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (position.isNotEmpty) data['position'] = position;
    if (industry.isNotEmpty) data['industry'] = industry;
    if (description.isNotEmpty) data['description'] = description;
    if (location.isNotEmpty) data['location'] = location;
    if (salary > 0)
      data['salary'] = salary; // Only include salary if it's greater than 0
    if (experienceLevel.isNotEmpty) data['experienceLevel'] = experienceLevel;
    if (locationType.isNotEmpty) data['locationType'] = locationType;
    if (employmentType.isNotEmpty) data['employmentType'] = employmentType;

    return data;
  }
}
