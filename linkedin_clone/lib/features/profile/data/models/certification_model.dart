import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationModel extends Equatable {
  final String name;
  final String issuingOrganization;
  final String? issuingOrganizationPic;
  final String issueDate;
  final String? expirationDate;

  const CertificationModel({
    required this.name,
    required this.issuingOrganization,
    this.issuingOrganizationPic,
    required this.issueDate,
    this.expirationDate,
  });

  /// Convert to Domain Entity
  Certification toEntity() {
    return Certification(
      name: name,
      issuingOrganization: issuingOrganization,
      issuingOrganizationPic: issuingOrganizationPic,
      issueDate: issueDate,
      expirationDate: expirationDate,
    );
  }

  /// Create from Domain Entity
  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      name: entity.name,
      issuingOrganization: entity.issuingOrganization,
      issuingOrganizationPic: entity.issuingOrganizationPic,
      issueDate: entity.issueDate,
      expirationDate: entity.expirationDate,
    );
  }

  /// Convert JSON to `CertificationModel`
  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      name: json['name'] as String,
      issuingOrganization: json['issuingOrganization'] as String,
      issuingOrganizationPic: json['issuingOrganizationPic'] as String?,
      issueDate: json['issueDate'] as String,
      expirationDate: json['expirationDate'] as String?,
    );
  }

  /// Convert `CertificationModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuingOrganization': issuingOrganization,
      'issuingOrganizationPic': issuingOrganizationPic,
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
        issuingOrganizationPic,
        issueDate,
        expirationDate,
      ];
}