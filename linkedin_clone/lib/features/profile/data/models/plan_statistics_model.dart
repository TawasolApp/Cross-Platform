import 'package:linkedin_clone/features/profile/domain/entities/plan_statistics.dart';

class PlanStatisticsModel extends PlanStatistics {
  const PlanStatisticsModel({
    required super.messageCount,
    required super.applicationCount,
  });

  /// Convert JSON to `PlanStatisticsModel`
  factory PlanStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PlanStatisticsModel(
      messageCount: json['message_count'] as int,
      applicationCount: json['application_count'] as int,
    );
  }

  /// Convert `PlanStatisticsModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'message_count': messageCount,
      'application_count': applicationCount,
    };
  }

  PlanStatisticsModel copyWith({
    int? messageCount,
    int? applicationCount,
  }) {
    return PlanStatisticsModel(
      messageCount: messageCount ?? this.messageCount,
      applicationCount: applicationCount ?? this.applicationCount,
    );
  }
}
