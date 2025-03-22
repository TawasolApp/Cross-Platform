import 'package:equatable/equatable.dart';

class PlanStatistics extends Equatable {
  final int messageCount;
  final int applicationCount;

  const PlanStatistics({
    required this.messageCount,
    required this.applicationCount,
  });

  @override
  List<Object?> get props => [messageCount, applicationCount];
}
