import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/premium/domain/usecases/cancel_use_case.dart';
import 'package:linkedin_clone/features/premium/domain/usecases/subscribe_to_premium_plan_usecase.dart';

enum ChoiceListType { report, premium }

class PremiumProvider with ChangeNotifier {
  bool _optionSelected = false;
  bool get optionSelected => _optionSelected;
  set optionSelected(bool value) {
    _optionSelected = value;
    notifyListeners();
  }

  SubscribeToPremiumPlanUseCase subscribeToPremiumPlanUseCase;
  CancelUseCase cancelUseCase;
  PremiumProvider({
    required this.subscribeToPremiumPlanUseCase,
    required this.cancelUseCase,
  });

  Future<String?> subscribeToPremiumPlan(
    bool isYearly,
    bool autoRenewal,
  ) async {
    try {
      final url = await subscribeToPremiumPlanUseCase.call(
        isYearly,
        autoRenewal,
      );
      return url;
    } catch (e) {
      print('PremiumProvider: subscribeToPremiumPlan error: $e');
      return null;
    }
  }

  Future<bool> cancelSubscription() async {
    try {
      final response = await cancelUseCase.call();
      return response;
    } catch (e) {
      print('PremiumProvider: cancelSubscription error: $e');
      return false;
    }
  }
}
