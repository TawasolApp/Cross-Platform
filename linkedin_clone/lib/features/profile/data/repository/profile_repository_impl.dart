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
import 'package:linkedin_clone/features/profile/data/models/endorsement_model.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ConnectionChecker connectionChecker;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      final profileModel = await profileRemoteDataSource.getProfile();
      return right(profileModel.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createProfile(Profile profile) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.createProfile(ProfileModel.fromEntity(profile));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    String? name,
    String? profilePictureUrl,
    String? coverPhoto,
    String? resume,
    String? headline,
    String? bio,
    String? location,
    String? industry,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.updateProfile(
        name: name,
        profilePictureUrl: profilePictureUrl,
        coverPhoto: coverPhoto,
        resume: resume,
        headline: headline,
        bio: bio,
        location: location,
        industry: industry,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePicture() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteProfilePicture();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCoverPhoto() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteCoverPhoto();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, List<Experience>>> getExperiences() async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     final experiences = await profileRemoteDataSource.getExperiences();
  //     return right(experiences.map((e) => e.toEntity()).toList());
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> addExperience(Experience experience) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.addExperience(ExperienceModel.fromEntity(experience));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateExperience(Experience experience) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.updateExperience(ExperienceModel.fromEntity(experience));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExperience(String experienceId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteExperience(experienceId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, List<Education>>> getEducation() async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     final education = await profileRemoteDataSource.getEducation();
  //     return right(education.map((e) => e.toEntity()).toList());
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> addEducation(Education education) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.addEducation(EducationModel.fromEntity(education));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateEducation(Education education) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.updateEducation(EducationModel.fromEntity(education));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEducation(String educationId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteEducation(educationId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, List<Skill>>> getSkills() async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     final skills = await profileRemoteDataSource.getSkills();
  //     return right(skills.map((s) => s.toEntity()).toList());
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> addSkill(Skill skill) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.addSkill(SkillModel.fromEntity(skill));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateSkill(Skill skill) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.updateSkill(SkillModel.fromEntity(skill));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSkill(String skillId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteSkill(skillId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, List<Certification>>> getCertifications() async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     final certifications = await profileRemoteDataSource.getCertifications();
  //     return right(certifications.map((c) => c.toEntity()).toList());
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, void>> addCertification(Certification certification) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.addCertification(CertificationModel.fromEntity(certification));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateCertification(Certification certification) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.updateCertification(CertificationModel.fromEntity(certification));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCertification(String certificationId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      await profileRemoteDataSource.deleteCertification(certificationId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  // @override
  // Future<Either<Failure, void>> endorseSkill(String skillId, String endorserId) async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     await profileRemoteDataSource.endorseSkill(skillId, endorserId);
  //     return right(null);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> removeEndorsement(String skillId, String endorserId) async {
  //   try {
  //     if (!await connectionChecker.isConnected) {
  //       return left(Failure("No internet connection"));
  //     }
  //     await profileRemoteDataSource.removeEndorsement(skillId, endorserId);
  //     return right(null);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }
}