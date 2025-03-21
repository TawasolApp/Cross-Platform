import 'package:hive/hive.dart';
import '../models/profile_model.dart';
import 'profile_data_source.dart';

class ProfileLocalDataSource implements ProfileDataSource {
  final Box _profileBox;

  ProfileLocalDataSource(this._profileBox);

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final data = _profileBox.get(userId);
    if (data != null) {
      return ProfileModel.fromJson(Map<String, dynamic>.from(data));
    } else {
      throw Exception('No profile found locally');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    await _profileBox.put(profile.userId, profile.toJson());
  }
}
