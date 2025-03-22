import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/plan_details_model.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';

abstract class ProfileRemoteDataSource {
  /// Profile Management
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateProfile(ProfileModel profile);
  Future<void> createProfile(ProfileModel profile);
  // Future<void> deleteProfile(String userId);

  /// Profile Picture Management
  // Future<String> uploadProfilePicture(String image);
  // Future<String> updateProfilePicture(String userId, String imagePath);
  Future<void> deleteProfilePicture();

  /// Cover Photo Management
  // Future<String> uploadCoverPhoto(String image);
  // Future<String> updateCoverPhoto(String userId, String imagePath);
  Future<void> deleteCoverPhoto();

  /// Experience Management
  // Future<List<ExperienceModel>> getExperiences(String userId);
  Future<void> addExperience(ExperienceModel experience);
  Future<void> updateExperience(ExperienceModel experience);
  Future<void> deleteExperience(String experience);

  /// Education Management
  // Future<List<EducationModel>> getEducation(String userId);
  Future<void> addEducation(EducationModel education);
  Future<void> updateEducation(EducationModel education);
  Future<void> deleteEducation(String education);

  /// Skills Management
  // Future<List<SkillModel>> getSkills(String userId);
  Future<void> addSkill(SkillModel skill);
  Future<void> updateSkill(SkillModel skill);
  Future<void> deleteSkill(String skill);

  /// Certification Management
  // Future<List<CertificationModel>> getCertifications(String userId);
  Future<void> addCertification(CertificationModel certification);
  Future<void> updateCertification(CertificationModel certification);
  Future<void> deleteCertification(String certification);

  /// Plan & Subscription Management
  // Future<PlanDetailsModel> getPlanDetails(String userId);
  // Future<void> updatePlan(String userId, PlanDetailsModel planDetails);
}