import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String? certificationId; // Added ID field
  final String name;
  final String company;
  final String? companyPic;
  final String issueDate;
  final String? expirationDate;

  const Certification({
    this.certificationId, // Added as optional
    required this.name,
    required this.company,
    this.companyPic,
    required this.issueDate,
    this.expirationDate,
  });

  Certification copyWith({
    String? certificationId,
    String? name,
    String? company,
    String? companyPic,
    String? issueDate,
    String? expirationDate,
  }) {
    return Certification(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      companyPic:
          companyPic ?? this.companyPic,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [
    certificationId,
    name,
    company,
    companyPic,
    issueDate,
    expirationDate,
  ];
}
