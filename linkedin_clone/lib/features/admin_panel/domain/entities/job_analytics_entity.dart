import '../../../jobs/domain/entities/job_entity.dart';

class MostAppliedCompany {
  final String id;
  final int applicationCount;

  MostAppliedCompany({required this.id, required this.applicationCount});
  factory MostAppliedCompany.fromJson(Map<String, dynamic> json) {
    return MostAppliedCompany(
      id: json['_id'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
    );
  }
}

class JobAnalytics {
  final int totalJobs;
  final MostAppliedCompany mostAppliedCompany;
  final Job mostAppliedJob;

  JobAnalytics({
    required this.totalJobs,
    required this.mostAppliedCompany,
    required this.mostAppliedJob,
  });
  factory JobAnalytics.fake() => JobAnalytics(
    totalJobs: 300,
    mostAppliedCompany: MostAppliedCompany(id: 'c1', applicationCount: 50),
    mostAppliedJob: Job(
      id: 'j1',
      companyName: 'Tech Corp',
      location: 'New York',
      description: 'Develop and maintain software applications.',
      position: 'Software Engineer',
      companyId: 'c1',
      companyLogo: 'https://example.com/logo.png',
      isFlagged: false,
      isSaved: false,
      applicantCount: 100,
      salary: 120000,
      experienceLevel: 'Mid-level',
      employmentType: 'Full-time',
      company: 'Tech Corp',
      status: 'active',
      industry: 'Technology',
      locationType: 'On-site',
      postedDate: DateTime.now().subtract(Duration(days: 10)),
      isOpen: true,
      companyAddress: '123 Tech St, New York, NY',
      companyDescription:
          'A leading tech company specializing in software development.',
      companyLocation: 'New York, NY',
      applicationLink: 'https://example.com/apply',
    ),
  );
}
