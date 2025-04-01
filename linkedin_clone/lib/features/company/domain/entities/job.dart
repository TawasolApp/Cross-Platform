class Job {
  final String id;
  final String position;
  final String company;
  final String industry;
  final String description;
  final String location;
  final double salary;
  final String experienceLevel;
  final String locationType;
  final String employmentType;
  final DateTime postedDate;
  final int applicantCount;

  Job({
    required this.id,
    required this.position,
    required this.company,
    required this.industry,
    required this.description,
    required this.location,
    required this.salary,
    required this.experienceLevel,
    required this.locationType,
    required this.employmentType,
    required this.postedDate,
    required this.applicantCount,
  });
}
