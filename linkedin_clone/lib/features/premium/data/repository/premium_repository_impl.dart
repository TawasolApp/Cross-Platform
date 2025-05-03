import 'package:linkedin_clone/features/premium/domain/repository/premium_repository.dart';

import '../datasources/premium_remote_data_source.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumRemoteDataSource remoteDataSource;

  PremiumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> subscribeToPremiumPlan(bool isYearly, bool autoRenewal) async {
    try {
      final url = await remoteDataSource.subscribeToPremiumPlan(
        isYearly: isYearly,
        autoRenewal: autoRenewal,
      );
      if (url == null) {
        throw Exception("Failed to get subscription URL");
      }
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
