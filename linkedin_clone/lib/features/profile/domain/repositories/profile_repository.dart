import '../entities/profile.dart';
import '../entities/experience.dart';
import '../entities/education.dart';
import '../entities/skill.dart';
import '../entities/certification.dart';
import '../entities/endorsement.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  /// Profile Management
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, void>> createProfile(Profile profile);
  Future<Either<Failure, void>> updateProfile(Profile profile);

  /// Profile components deletion
  Future<Either<Failure, void>> deleteProfilePicture();
  Future<Either<Failure, void>> deleteCoverPhoto();
  Future<Either<Failure, void>> deleteResume();
  Future<Either<Failure, void>> deleteHeadline();
  Future<Either<Failure, void>> deleteBio();
  Future<Either<Failure, void>> deleteLocation();
  Future<Either<Failure, void>> deleteIndustry();

  /// Skills Management
  Future<Either<Failure, void>> addSkill(Skill skill);
  Future<Either<Failure, void>> updateSkill(String skillName, Skill skill);
  Future<Either<Failure, void>> deleteSkill(String skillName);

  /// Education Management
  Future<Either<Failure, void>> addEducation(Education education);
  Future<Either<Failure, void>> updateEducation(
    String educationId,
    Education education,
  );
  Future<Either<Failure, void>> deleteEducation(String educationId);

  /// Certification Management
  Future<Either<Failure, void>> addCertification(Certification certification);
  Future<Either<Failure, void>> updateCertification(
    String certificationId,
    Certification certification,
  );
  Future<Either<Failure, void>> deleteCertification(String certificationId);

  /// Work Experience Management
  Future<Either<Failure, void>> addWorkExperience(Experience experience);
  Future<Either<Failure, void>> updateWorkExperience(
    String workExperienceId,
    Experience experience,
  );
  Future<Either<Failure, void>> deleteWorkExperience(String workExperienceId);

  /// Additional profile features
  Future<Either<Failure, List<dynamic>>> getFollowedCompanies(String userId);
  Future<Either<Failure, List<dynamic>>> getPosts(String userId);

  /// Endorsements
  Future<Either<Failure, List<Endorsement>>> getSkillEndorsements(
    String userId,
    String skillName,
  );
}
