class ApplicationEntity {
  final String applicationId;
  final String applicantId;
  final String applicantName;
  final String applicantEmail;
  final String applicantPicture;
  final String applicantHeadline;
  final String applicantPhoneNumber;
  final String resumeUrl;
  final String status; // Pending, Viewed, Rejected, Accepted
  final DateTime appliedDate;
  ApplicationEntity copyWith({
    String? applicationId,
    String? applicantId,
    String? applicantName,
    String? applicantEmail,
    String? applicantPicture,
    String? applicantHeadline,
    String? applicantPhoneNumber,
    String? resumeUrl,
    String? status,
    DateTime? appliedDate,
  }) {
    return ApplicationEntity(
      applicationId: applicationId ?? this.applicationId,
      applicantId: applicantId ?? this.applicantId,
      applicantName: applicantName ?? this.applicantName,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      applicantPicture: applicantPicture ?? this.applicantPicture,
      applicantHeadline: applicantHeadline ?? this.applicantHeadline,
      applicantPhoneNumber: applicantPhoneNumber ?? this.applicantPhoneNumber,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
    );
  }
  ApplicationEntity({
    required this.applicationId,
    required this.applicantId,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPicture,
    required this.applicantHeadline,
    required this.applicantPhoneNumber,
    required this.resumeUrl,
    required this.status,
    required this.appliedDate,
  });
  
}
