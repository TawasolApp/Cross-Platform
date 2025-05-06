import 'package:linkedin_clone/features/privacy/data/models/privacy_user_model.dart';
import 'package:linkedin_clone/features/privacy/domain/entities/privacy_user_entity.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_enums.dart';
import '../datasources/privacy_remote_data_source.dart';
import '../../domain/repository/privacy_repository.dart';

class PrivacyRepositoryImpl implements PrivacyRepository {
  final PrivacyRemoteDataSource remoteDataSource;

  PrivacyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PrivacyUserEntity>> getBlockedList() async {
    try {
      final blockedList = await remoteDataSource.getBlockedList();
      return blockedList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> blockUser(String userId) async {
    try {
      final blocked = await remoteDataSource.blockUser(userId);
      return blocked;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> unblockUser(String userId) async {
    try {
      final unblocked = await remoteDataSource.unblockUser(userId);
      return unblocked;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> reportUser(String userId, String reason) async {
    try {
      final reported = await remoteDataSource.reportUser(userId, reason);
      return reported;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> reportPost(String postId, String reason) async {
    try {
      final reported = await remoteDataSource.reportPost(postId, reason);
      return reported;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> reportJob(String jobId, String reason) async {
    try {
      final reported = await remoteDataSource.reportJob(jobId, reason);
      return reported;
    } catch (e) {
      rethrow;
    }
  }
}
