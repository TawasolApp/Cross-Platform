import '../../domain/entities/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  ApplicationModel({
    required String applicationId,
    required String applicantId,
    required String applicantName,
    required String applicantEmail,
    required String applicantPicture,
    required String applicantHeadline,
    required String applicantPhoneNumber,
    required String resumeUrl,
    required String status,
    required DateTime appliedDate,
  }) : super(
          applicationId: applicationId,
          applicantId: applicantId,
          applicantName: applicantName,
          applicantEmail: applicantEmail,
          applicantPicture: applicantPicture,
          applicantHeadline: applicantHeadline,
          applicantPhoneNumber: applicantPhoneNumber,
          resumeUrl: resumeUrl,
          status: status,
          appliedDate: appliedDate,
        );

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      applicationId: json['applicationId'] ?? '',
      applicantId: json['applicantId'] ?? '',
      applicantName: json['applicantName'] ?? '',
      applicantEmail: json['applicantEmail'] ?? '',
      applicantPicture: json['applicantPicture'] ?? '',
      applicantHeadline: json['applicantHeadline'] ?? '',
      applicantPhoneNumber: json['applicantPhoneNumber'] ?? '',
      resumeUrl: json['resumeURL'] ?? '',
      status: json['status'] ?? 'Pending',
      appliedDate: DateTime.tryParse(json['appliedDate'] ?? '') ?? DateTime.now(),
    );
  }
}
