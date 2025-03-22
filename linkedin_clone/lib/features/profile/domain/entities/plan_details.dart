import 'package:equatable/equatable.dart';

class PlanDetails extends Equatable {
  final String planType;
  final String startDate;
  final String expiryDate;
  final bool autoRenewal;
  final String? cancelDate; // Optional field

  const PlanDetails({
    required this.planType,
    required this.startDate,
    required this.expiryDate,
    required this.autoRenewal,
    this.cancelDate,
  });

  @override
  List<Object?> get props => [
        planType,
        startDate,
        expiryDate,
        autoRenewal,
        cancelDate,
      ];
}
