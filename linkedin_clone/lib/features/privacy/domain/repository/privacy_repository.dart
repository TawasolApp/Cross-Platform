import '../entities/privacy_user_entity.dart';

abstract class PrivacyRepository {
  Future<List<PrivacyUserEntity>> getBlockedList();

  Future<bool> unblockUser(String userId);
  Future<bool> blockUser(String userId);
  Future<bool> reportUser(String userId, String reason);
  Future<bool> reportPost(String postId, String reason);
  Future<bool> reportJob(String jobId, String reason);
}
