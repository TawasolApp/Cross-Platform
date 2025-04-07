import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';

abstract class ProfileRemoteDataSource {
  /// Profile Management
  Future<ProfileModel> getProfile(String id);
  Future<void> createProfile(ProfileModel profile);
  Future<void> updateProfile(ProfileModel profile);
  
  /// Profile components deletion
  Future<void> deleteProfilePicture();
  Future<void> deleteCoverPhoto();
  Future<void> deleteResume();
  Future<void> deleteHeadline();
  Future<void> deleteBio();
  Future<void> deleteLocation();
  Future<void> deleteIndustry();

  /// Skills Management
  Future<void> addSkill(SkillModel skill);
  Future<void> updateSkill(String skillName, SkillModel skill);
  Future<void> deleteSkill(String skillName);

  /// Education Management
  Future<void> addEducation(EducationModel education);
  Future<void> updateEducation(String educationId, EducationModel education);
  Future<void> deleteEducation(String educationId);

  /// Certification Management
  Future<void> addCertification(CertificationModel certification);
  Future<void> updateCertification(
    String certificationId,
    CertificationModel certification,
  );
  Future<void> deleteCertification(String certificationId);

  /// Work Experience Management
  Future<void> addWorkExperience(ExperienceModel experience);
  Future<void> updateWorkExperience(
    String workExperienceId,
    ExperienceModel experience,
  );
  Future<void> deleteWorkExperience(String workExperienceId);

  /// Additional profile features
  Future<List<dynamic>> getFollowedCompanies(String userId);
  Future<List<dynamic>> getPosts(String userId);
}
