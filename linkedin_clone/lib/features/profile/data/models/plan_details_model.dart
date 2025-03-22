import 'package:linkedin_clone/features/profile/domain/entities/plan_details.dart';

class PlanDetailsModel extends PlanDetails {
  const PlanDetailsModel({
    required super.planType,
    required super.startDate,
    required super.expiryDate,
    required super.autoRenewal,
    super.cancelDate,
  });

  /// Convert JSON to `PlanDetailsModel`
  factory PlanDetailsModel.fromJson(Map<String, dynamic> json) {
    return PlanDetailsModel(
      planType: json['plan_type'] as String,
      startDate: json['start_date'] as String,
      expiryDate: json['expiry_date'] as String,
      autoRenewal: json['auto_renewal'] as bool,
      cancelDate: json['cancel_date'] as String?,
    );
  }

  /// Convert `PlanDetailsModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'plan_type': planType,
      'start_date': startDate,
      'expiry_date': expiryDate,
      'auto_renewal': autoRenewal,
      'cancel_date': cancelDate,
    };
  }

  PlanDetailsModel copyWith({
    String? planType,
    String? startDate,
    String? expiryDate,
    bool? autoRenewal,
    String? cancelDate,
  }) {
    return PlanDetailsModel(
      planType: planType ?? this.planType,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      cancelDate: cancelDate ?? this.cancelDate,
    );
  }
}
