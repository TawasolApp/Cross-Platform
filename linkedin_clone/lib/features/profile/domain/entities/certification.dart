import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String? certificationId; // Added ID field
  final String name;
  final String company;
  final String? certificationPicture;
  final String issueDate;
  final String? expiryDate;

  const Certification({
    this.certificationId, // Added as optional
    required this.name,
    required this.company,
    this.certificationPicture,
    required this.issueDate,
    this.expiryDate,
  });

  Certification copyWith({
    String? certificationId,
    String? name,
    String? company,
    String? certificationPicture,
    String? issueDate,
    String? expiryDate,
  }) {
    return Certification(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      certificationPicture:
          certificationPicture ?? this.certificationPicture,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  List<Object?> get props => [
    certificationId,
    name,
    company,
    certificationPicture,
    issueDate,
    expiryDate,
  ];
}
