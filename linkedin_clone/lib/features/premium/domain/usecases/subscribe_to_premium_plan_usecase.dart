import 'package:linkedin_clone/features/premium/domain/repository/premium_repository.dart';

class SubscribeToPremiumPlanUseCase {
  final PremiumRepository repository;

  SubscribeToPremiumPlanUseCase(this.repository);

  Future<String?> call(bool isYearly, bool autoRenewal) async {
    try {
      return await repository.subscribeToPremiumPlan(isYearly, autoRenewal);
    } catch (e) {
      rethrow;
    }
  }
}
