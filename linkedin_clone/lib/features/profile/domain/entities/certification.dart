import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String? certificationId; // Added ID field
  final String name;
  final String company;
  final String? companyLogo;
  final String? companyId;
  final String issueDate;
  final String? expiryDate;

  const Certification({
    this.certificationId, // Added as optional
    required this.name,
    required this.company,
    this.companyLogo,
    this.companyId,
    required this.issueDate,
    this.expiryDate,
  });

  Certification copyWith({
    String? certificationId,
    String? name,
    String? company,
    String? companyLogo,
    String? companyId,
    String? issueDate,
    String? expiryDate,
  }) {
    return Certification(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      companyLogo:
          companyLogo ?? this.companyLogo,
      companyId: companyId ?? this.companyId,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  List<Object?> get props => [
    certificationId,
    name,
    company,
    companyLogo,
    companyId,
    issueDate,
    expiryDate,
  ];
}