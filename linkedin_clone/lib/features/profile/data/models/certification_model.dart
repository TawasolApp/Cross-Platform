import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class DateUtils {
  static String formatToYearMonth(String dateString) {
    try {
      // Handle various date formats that might come from API
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      // If format is unexpected, return as-is (you might want to throw an error instead)
      return dateString;
    } catch (e) {
      return dateString; // or throw FormatException('Invalid date format');
    }
  }
}
class CertificationModel extends Equatable {
  final String? certificationId;
  final String name;
  final String company;
  final String? certificationPicture;
  final String issueDate;
  final String? expiryDate;

  const CertificationModel({
    this.certificationId,
    required this.name,
    required this.company,
    this.certificationPicture,
    required this.issueDate,
    this.expiryDate,
  });

  /// Convert to Domain Entity
  Certification toEntity() {
    return Certification(
      certificationId: certificationId,
      name: name,
      company: company,
      certificationPicture: certificationPicture,
      issueDate: issueDate,
      expiryDate: expiryDate,
    );
  }

  /// Create from Domain Entity
  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      certificationId: entity.certificationId ?? '',// Providing default empty string if null
      name: entity.name,
      company: entity.company,
      certificationPicture: entity.certificationPicture,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
    );
  }

  /// Convert JSON to `CertificationModel`
  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      certificationId: json['_id'] as String? ?? '',
      name: json['name'] as String,
      company: json['company'] as String,
      certificationPicture: json['certificationPicture'] as String?,
      issueDate: DateUtils.formatToYearMonth(json['issueDate'] as String),
      expiryDate: json['expiryDate'] != null
          ? DateUtils.formatToYearMonth(json['expiryDate'] as String)
          : null,
    );
  }

  /// Convert `CertificationModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': certificationId,
      'name': name,
      'company': company,
      'certificationPicture': certificationPicture,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
    };
  }

  CertificationModel copyWith({
    String? name,
    String? issuingOrganization,
    String? issuingOrganizationPic,
    String? issueDate,
    String? expiryDate,
  }) {
    return CertificationModel(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      certificationPicture: certificationPicture ?? this.certificationPicture,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  List<Object?> get props => [
        name,
        company,
        certificationPicture,
        issueDate,
        expiryDate,
      ];
}