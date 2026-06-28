import 'package:linkedin_clone/features/premium/domain/repository/premium_repository.dart';

class CancelUseCase {
  final PremiumRepository repository;

  CancelUseCase(this.repository);

  Future<bool> call() async {
    try {
      return await repository.cancelSubscription();
    } catch (e) {
      rethrow;
    }
  }
}
