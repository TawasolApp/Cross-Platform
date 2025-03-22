import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class CertificationModel extends Certification with EquatableMixin {
  CertificationModel({
    required super.name,
    required super.issuingOrganization,
    super.issuingOrganizationPic,
    required super.issueDate,
    super.expirationDate,
  });

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
