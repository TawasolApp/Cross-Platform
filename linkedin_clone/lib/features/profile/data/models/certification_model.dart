import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationModel extends Equatable {
  final String name;
  final String issuingOrganization;
  final String? issuingOrganizationPic; // Nullable field for organization image URL
  final String issueDate;
  final String? expirationDate; // Optional if certification doesn't expire

  const CertificationModel({
    required this.name,
    required this.issuingOrganization,
    this.issuingOrganizationPic, // Now nullable
    required this.issueDate,
    this.expirationDate, // Nullable
  });

  /// Convert JSON to `CertificationModel`
  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      name: json['name'] as String,
      issuingOrganization: json['issuingOrganization'] as String,
      issuingOrganizationPic: json['issuingOrganizationPic'] as String?, // Nullable
      issueDate: json['issueDate'] as String,
      expirationDate: json['expirationDate'] as String?,
    );
  }

  /// Convert `CertificationModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuingOrganization': issuingOrganization,
      'issuingOrganizationPic': issuingOrganizationPic, // Nullable
      'issueDate': issueDate,
      'expirationDate': expirationDate,
    };
  }

  /// Convert `CertificationModel` to `Certification` entity
  Certification toEntity() {
    return Certification(
      name: name,
      issuingOrganization: issuingOrganization,
      issuingOrganizationPic: issuingOrganizationPic, // Nullable
      issueDate: issueDate,
      expirationDate: expirationDate,
    );
  }

  /// Create `CertificationModel` from `Certification` entity
  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      name: entity.name,
      issuingOrganization: entity.issuingOrganization,
      issuingOrganizationPic: entity.issuingOrganizationPic, // Nullable
      issueDate: entity.issueDate,
      expirationDate: entity.expirationDate,
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
