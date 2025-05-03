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
  final bool isOpen;
  final String companyId;
  final String companyName;
  final String companyLogo;
  final String companyAddress;
  final String companyLocation;
  final String companyDescription;
  final String applicationLink;
  final bool isSaved;
  final String status;
  final bool isFlagged;

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
    required this.isOpen,
    required this.companyId,
    required this.companyName,
    required this.companyLogo,
    required this.companyAddress,
    required this.companyLocation,
    required this.companyDescription,
    required this.applicationLink,
    required this.isSaved,
    required this.status,
    required this.isFlagged,
  });
  factory Job.fake({String id = 'jobId'}) => Job(
    id: id,
    position: "Dev",
    company: "LinkedIn",
    industry: "Tech",
    description: "Job desc",
    location: "Cairo",
    salary: 10000,
    experienceLevel: "Mid",
    locationType: "Remote",
    employmentType: "Full-time",
    postedDate: DateTime.now(),
    applicantCount: 5,
    isOpen: true,
    companyId: "c1",
    companyName: "LinkedIn",
    companyLogo: "",
    companyAddress: "Address",
    companyLocation: "Cairo",
    companyDescription: "Desc",
    applicationLink: "",
    isSaved: false,
    status: "Open",
    isFlagged: false,
  );
}
