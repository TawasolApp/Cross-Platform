import '../../domain/entities/reported_user_entity.dart';

class ReportedUserModel extends ReportedUser {
  ReportedUserModel({
    required super.id,
    required super.status,
    required super.reportedUser,
    required super.reportedUserRole,
    required super.reportedUserAvatar,
    required super.reportedBy,
    required super.reporterAvatar,
    required super.reason,
    required super.reportedAt,
  });

  factory ReportedUserModel.fromJson(Map<String, dynamic> json) {
    return ReportedUserModel(
      id: json['id'],
      status: json['status'],
      reportedUser: json['reportedUser'],
      reportedUserRole: json['reportedUserRole'],
      reportedUserAvatar: json['reportedUserAvatar'],
      reportedBy: json['reportedBy'],
      reporterAvatar: json['reporterAvatar'],
      reason: json['reason'],
      reportedAt: DateTime.parse(json['reportedAt']),
    );
  }
}
