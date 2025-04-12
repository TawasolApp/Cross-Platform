import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';

class DateUtils {
  static String formatToYearMonth(String dateString) {
    try {
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length >= 2) {
          return '${parts[0]}-${parts[1].padLeft(2, '0')}';
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }
}

class CertificationModel extends Equatable {
  final String? certificationId;
  final String name;
  final String company;
  final String? companyLogo;
  final String? companyId;
  final String issueDate;
  final String? expiryDate;

  const CertificationModel({
    this.certificationId,
    required this.name,
    required this.company,
    this.companyLogo,
    this.companyId,
    required this.issueDate,
    this.expiryDate,
  });

  /// Convert to Domain Entity
  Certification toEntity() {
    return Certification(
      certificationId: certificationId,
      name: name,
      company: company,
      companyLogo: companyLogo,
      companyId: companyId,
      issueDate: issueDate,
      expiryDate: expiryDate,
    );
  }

  /// Create from Domain Entity
  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      certificationId: entity.certificationId,
      name: entity.name,
      company: entity.company,
      companyLogo: entity.companyLogo,
      companyId: entity.companyId,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
    );
  }

  /// Convert JSON to `CertificationModel`
  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      certificationId: json['_id'] as String?,
      name: json['name'] as String,
      company: json['company'] as String,
      companyLogo: json['companyLogo'] as String?,
      companyId: json['companyId'] as String?,
      issueDate: DateUtils.formatToYearMonth(json['issueDate'] as String),
      expiryDate:
          json['expiryDate'] != null
              ? DateUtils.formatToYearMonth(json['expiryDate'] as String)
              : null,
    );
  }

  /// Convert `CertificationModel` to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'company': company,
      'issueDate': issueDate,
    };

    // Only include these fields if they're not null
    if (certificationId != null && certificationId!.isNotEmpty) {
      data['_id'] = certificationId;
    }
    if (companyLogo != null) {
      data['companyLogo'] = companyLogo;
    }
    if (companyId != null) {
      data['companyId'] = companyId;
    }
    if (expiryDate != null) {
      data['expiryDate'] = expiryDate;
    }

    return data;
  }

  /// Create a copy with modified fields
  CertificationModel copyWith({
    String? certificationId,
    String? name,
    String? company,
    String? companyLogo,
    String? companyId,
    String? issueDate,
    String? expiryDate,
  }) {
    return CertificationModel(
      certificationId: certificationId ?? this.certificationId,
      name: name ?? this.name,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
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
