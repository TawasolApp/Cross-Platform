import 'package:linkedin_clone/features/profile/domain/repository/profile_repository.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final profileModel = await remoteDataSource.getProfile(userId);
      await localDataSource.updateProfile(profileModel); // Cache latest data
      return profileModel.toEntity(); // Convert to domain entity
    } catch (_) {
      final cachedProfile = await localDataSource.getProfile(userId);
      return cachedProfile.toEntity(); // Fallback to local cache
    }
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final profileModel = ProfileModel.fromEntity(profile);
    await remoteDataSource.updateProfile(profileModel);
    await localDataSource.updateProfile(profileModel);
  }
}
