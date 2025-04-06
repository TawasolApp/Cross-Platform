import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationModel extends Equatable {
  final String? certificationId;
  final String name;
  final String company;
  final String? companyPic;
  final String issueDate;
  final String? expirationDate;

  const CertificationModel({
    this.certificationId,
    required this.name,
    required this.company,
    this.companyPic,
    required this.issueDate,
    this.expirationDate,
  });

  /// Convert to Domain Entity
  Certification toEntity() {
    return Certification(
      certificationId: certificationId,
      name: name,
      company: company,
      companyPic: companyPic,
      issueDate: issueDate,
      expirationDate: expirationDate,
    );
  }

  /// Create from Domain Entity
  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      certificationId: entity.certificationId ?? '',// Providing default empty string if null
      name: entity.name,
      company: entity.company,
      companyPic: entity.companyPic,
      issueDate: entity.issueDate,
      expirationDate: entity.expirationDate,
    );
  }

  /// Convert JSON to `CertificationModel`
  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      certificationId: json['_id'] as String? ?? '', // Assuming ID is optional
      name: json['name'] as String,
      company: json['company'] as String,
      companyPic: json['companyPic'] as String?,
      issueDate: json['issueDate'] as String,
      expirationDate: json['expirationDate'] as String?,
    );
  }

  /// Convert `CertificationModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': certificationId,
      'name': name,
      'company': company,
      'companyPic': companyPic,
      'issueDate': issueDate,
      'expirationDate': expirationDate,
    };
  }

  CertificationModel copyWith({
    String? name,
    String? issuingOrganization,
    String? issuingOrganizationPic,
    String? issueDate,
    String? expirationDate,
  }) {
    return CertificationModel(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      companyPic: companyPic ?? this.companyPic,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [
        name,
        company,
        companyPic,
        issueDate,
        expirationDate,
      ];
}