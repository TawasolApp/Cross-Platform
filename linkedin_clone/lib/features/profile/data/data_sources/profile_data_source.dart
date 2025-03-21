import '../models/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateProfile(ProfileModel profile);
}
