import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String name;
  final String issuingOrganization;
  final String? issuingOrganizationPic; // Nullable field
  final String issueDate;
  final String? expirationDate;

  const Certification({
    required this.name,
    required this.issuingOrganization,
    this.issuingOrganizationPic, // Now nullable
    required this.issueDate,
    this.expirationDate,
  });

  Certification copyWith({
    String? name,
    String? issuingOrganization,
    String? issuingOrganizationPic,
    String? issueDate,
    String? expirationDate,
  }) {
    return Certification(
      name: name ?? this.name,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issuingOrganizationPic: issuingOrganizationPic ?? this.issuingOrganizationPic,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [
        name,
        issuingOrganization,
        issuingOrganizationPic, // Nullable in props
        issueDate,
        expirationDate,
      ];
}
