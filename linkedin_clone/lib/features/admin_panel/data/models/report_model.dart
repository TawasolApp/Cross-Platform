import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  ReportModel({
    required super.id,
    required super.type,
    required super.reportedBy,
    required super.reason,
    required super.status,
    required super.reportedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      type: json['type'],
      reportedBy: json['reported_by'],
      reason: json['reason'],
      status: json['status'],
      reportedAt: DateTime.parse(json['reported_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'reported_by': reportedBy,
      'reason': reason,
      'status': status,
      'reported_at': reportedAt.toIso8601String(),
    };
  }
}
