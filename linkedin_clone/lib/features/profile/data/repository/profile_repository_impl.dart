import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/errors/exceptions.dart';
import 'package:linkedin_clone/core/network/connection_checker.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_data_source.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';
import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/endorsement_model.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  // final ConnectionChecker connectionChecker;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    // required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      final profileModel = await profileRemoteDataSource.getProfile(id);
      return right(profileModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> createProfile(Profile profile) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 400));
      // }
      await profileRemoteDataSource.createProfile(
        ProfileModel.fromEntity(profile),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.updateProfile(
        ProfileModel.fromEntity(profile),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Profile component deletion methods
  @override
  Future<Either<Failure, void>> deleteProfilePicture() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteProfilePicture();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCoverPhoto() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteCoverPhoto();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResume() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteResume();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHeadline() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteHeadline();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBio() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteBio();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocation() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteLocation();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIndustry() async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteIndustry();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Work Experience methods
  @override
  Future<Either<Failure, void>> addWorkExperience(Experience experience) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.addWorkExperience(
        ExperienceModel.fromEntity(experience),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkExperience(
    String workExperienceId,
    Experience experience,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.updateWorkExperience(
        workExperienceId,
        ExperienceModel.fromEntity(experience),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkExperience(
    String workExperienceId,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteWorkExperience(workExperienceId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Education methods
  @override
  Future<Either<Failure, void>> addEducation(Education education) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.addEducation(
        EducationModel.fromEntity(education),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> updateEducation(
    String educationId,
    Education education,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.updateEducation(
        educationId,
        EducationModel.fromEntity(education),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEducation(String educationId) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteEducation(educationId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Skill methods
  @override
  Future<Either<Failure, void>> addSkill(Skill skill) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.addSkill(SkillModel.fromEntity(skill));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSkill(String skillName) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteSkill(skillName);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Certification methods
  @override
  Future<Either<Failure, void>> addCertification(
    Certification certification,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.addCertification(
        CertificationModel.fromEntity(certification),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> updateCertification(
    String certificationId,
    Certification certification,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.updateCertification(
        certificationId,
        CertificationModel.fromEntity(certification),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCertification(
    String certificationId,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      await profileRemoteDataSource.deleteCertification(certificationId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  // Additional profile features
  @override
  Future<Either<Failure, List<dynamic>>> getFollowedCompanies(
    String userId,
  ) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      final companies = await profileRemoteDataSource.getFollowedCompanies(
        userId,
      );
      return right(companies);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getPosts(String userId) async {
    try {
      // if (!await connectionChecker.isConnected) {
      //   return left(Failure(message: "No internet connection", errorCode: 500));
      // }
      final posts = await profileRemoteDataSource.getPosts(userId);
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(message: e.message, errorCode: 400));
    }
  }
}
