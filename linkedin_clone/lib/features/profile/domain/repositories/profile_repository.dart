import '../entities/profile.dart';
import '../entities/experience.dart';
import '../entities/education.dart';
import '../entities/skill.dart';
import '../entities/certification.dart';
// import '../entities/plan_details.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  /// Profile Management
  Future<Either<Failure, Profile>> getProfile(String userId);
  Future<Either<Failure, void>> createProfile(Profile profile);
  Future<Either<Failure, void>> updateProfile(Profile profile);
  // Future<Either<Failure, void>> deleteProfile(String userId);

  /// Profile Picture Management
  // Future<Either<Failure, String>> uploadProfilePicture(String image);
  // Future<Either<Failure, String>> updateProfilePicture(String imagePath);
  Future<Either<Failure, void>> deleteProfilePicture();

  /// Cover Photo Management
  // Future<Either<Failure, String>> uploadCoverPhoto(String image);
  // Future<Either<Failure, String>> updateCoverPhoto(String imagePath);
  Future<Either<Failure, void>> deleteCoverPhoto();

  /// Experience Management
  // Future<Either<Failure, List<Experience>>> getExperiences(String userId);
  Future<Either<Failure, void>> addExperience(Experience experience);
  Future<Either<Failure, void>> updateExperience(Experience experience);
  Future<Either<Failure, void>> deleteExperience(String experience);

  /// Education Management
  // Future<Either<Failure, List<Education>>> getEducation(String userId);
  Future<Either<Failure, void>> addEducation(Education education);
  Future<Either<Failure, void>> updateEducation(Education education);
  Future<Either<Failure, void>> deleteEducation(String education);

  /// Skills Management
  // Future<Either<Failure, List<Skill>>> getSkills(String userId);
  Future<Either<Failure, void>> addSkill(Skill skill);
  Future<Either<Failure, void>> updateSkill(Skill skill);
  Future<Either<Failure, void>> deleteSkill(String skill);

  /// Certification Management
  // Future<Either<Failure, List<Certification>>> getCertifications(String userId);
  Future<Either<Failure, void>> addCertification(Certification certification);
  Future<Either<Failure, void>> updateCertification(Certification certification);
  Future<Either<Failure, void>> deleteCertification(String certification);

  /// Plan & Subscription Management
  // Future<Either<Failure, PlanDetails>> getPlanDetails(String userId);
  // Future<Either<Failure, void>> updatePlan(String userId, PlanDetails planDetails);
}
