/// Repository responsible for handling premium features and subscriptions
abstract class PremiumRepository {
  Future<String> subscribeToPremiumPlan(bool isYearly, bool autoRenewal);
  Future<bool> cancelSubscription();
}
