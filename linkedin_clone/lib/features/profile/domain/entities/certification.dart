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

  @override
  List<Object?> get props => [
        name,
        issuingOrganization,
        issuingOrganizationPic, // Nullable in props
        issueDate,
        expirationDate,
      ];
}
