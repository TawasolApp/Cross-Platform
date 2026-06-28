class CreateJobEntity {
  final String position;
  final String industry;
  final String description;
  final String location;
  final double salary;
  final String experienceLevel;
  final String locationType;
  final String employmentType;

  CreateJobEntity({
    required this.position,
    required this.industry,
    required this.description,
    required this.location,
    required this.salary,
    required this.experienceLevel,
    required this.locationType,
    required this.employmentType,
  });
}
