import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_cover_photo.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
import 'package:linkedin_clone/core/errors/failures.dart';

class ProfileProvider extends ChangeNotifier {
  // Use cases
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  final DeleteProfilePictureUseCase deleteProfilePictureUseCase;
  final UpdateCoverPictureUseCase updateCoverPictureUseCase;
  final DeleteCoverPhotoUseCase deleteCoverPhotoUseCase;
  final UpdateHeadlineUseCase updateHeadlineUseCase;
  final UpdateIndustryUseCase updateIndustryUseCase;
  final UpdateLocationUseCase updateLocationUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final UpdateResumeUseCase updateResumeUseCase;
  final UpdateBioUseCase updateBioUseCase;
  final AddExperienceUseCase addExperienceUseCase;
  final UpdateExperienceUseCase updateExperienceUseCase;
  final DeleteExperienceUseCase deleteExperienceUseCase;
  final AddSkillUseCase addSkillUseCase;
  final UpdateSkillUseCase updateSkillUseCase;
  final DeleteSkillUseCase deleteSkillUseCase;
  final AddEducationUseCase addEducationUseCase;
  final UpdateEducationUseCase updateEducationUseCase;
  final DeleteEducationUseCase deleteEducationUseCase;
  final AddCertificationUseCase addCertificationUseCase;
  final UpdateCertificationUseCase updateCertificationUseCase;
  final DeleteCertificationUseCase deleteCertificationUseCase;

  // Profile data
  String? _userId;
  String? _name;
  String? _profilePicture;
  String? _coverPhoto;
  String? _resume;
  String? _headline;
  String? _bio;
  String? _location;
  String? _industry;
  List<Skill>? _skills;
  List<Education>? _educations;
  List<Certification>? _certifications;
  List<Experience>? _experiences;
  String? _visibility;
  int? _connectionCount;

  // Expansion states
  bool _isExpandedBio = false;
  bool _isExpandedExperiences = false;
  bool _isExpandedEducation = false;
  bool _isExpandedCertifications = false;
  bool _isExpandedSkills = false;

  // Error states
  String? _experienceError;
  String? _educationError;
  String? _skillError;
  String? _certificationError;
  String? _bioError;
  String? _profileError;
  String? _resumeError; // Add resume error state
  bool _isLoading = false;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfilePictureUseCase,
    required this.deleteProfilePictureUseCase,
    required this.updateCoverPictureUseCase,
    required this.deleteCoverPhotoUseCase,
    required this.updateHeadlineUseCase,
    required this.updateIndustryUseCase,
    required this.updateLocationUseCase,
    required this.updateNameUseCase,
    required this.updateResumeUseCase,
    required this.updateBioUseCase,
    required this.addExperienceUseCase,
    required this.updateExperienceUseCase,
    required this.deleteExperienceUseCase,
    required this.addEducationUseCase,
    required this.updateEducationUseCase,
    required this.deleteEducationUseCase,
    required this.addCertificationUseCase,
    required this.updateCertificationUseCase,
    required this.deleteCertificationUseCase,
    required this.addSkillUseCase,
    required this.updateSkillUseCase,
    required this.deleteSkillUseCase,
  });

  // Getters
  String? get userId => _userId;
  String? get name => _name;
  String? get profilePicture => _profilePicture;
  String? get coverPhoto => _coverPhoto;
  String? get resume => _resume;
  String? get headline => _headline;
  String? get bio => _bio;
  String? get location => _location;
  String? get industry => _industry;
  List<Skill>? get skills => _skills;
  List<Education>? get educations => _educations;
  List<Certification>? get certifications => _certifications;
  List<Experience>? get experiences => _experiences;
  String? get visibility => _visibility;
  int? get connectionCount => _connectionCount;

  // Expansion state getters
  bool get isExpandedBio => _isExpandedBio;
  bool get isExpandedExperiences => _isExpandedExperiences;
  bool get isExpandedEducation => _isExpandedEducation;
  bool get isExpandedCertifications => _isExpandedCertifications;
  bool get isExpandedSkills => _isExpandedSkills;

  // Error state getters
  String? get experienceError => _experienceError;
  String? get educationError => _educationError;
  String? get skillError => _skillError;
  String? get certificationError => _certificationError;
  String? get bioError => _bioError;
  String? get profileError => _profileError;
  String? get resumeError => _resumeError; // Add resumeError getter
  bool get isLoading => _isLoading;

  // Setters
  set userId(String? value) {
    _userId = value;
    notifyListeners();
  }

  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set profilePicture(String? value) {
    _profilePicture = value;
    notifyListeners();
  }

  set coverPhoto(String? value) {
    _coverPhoto = value;
    notifyListeners();
  }

  set resume(String? value) {
    _resume = value;
    notifyListeners();
  }

  set headline(String? value) {
    _headline = value;
    notifyListeners();
  }

  set bio(String? value) {
    _bio = value;
    notifyListeners();
  }

  set location(String? value) {
    _location = value;
    notifyListeners();
  }

  set industry(String? value) {
    _industry = value;
    notifyListeners();
  }

  set skills(List<Skill>? value) {
    _skills = value;
    notifyListeners();
  }

  set educations(List<Education>? value) {
    _educations = value;
    notifyListeners();
  }

  set certifications(List<Certification>? value) {
    _certifications = value;
    notifyListeners();
  }

  set experiences(List<Experience>? value) {
    _experiences = value;
    notifyListeners();
  }

  set visibility(String? value) {
    _visibility = value;
    notifyListeners();
  }

  set connectionCount(int? value) {
    _connectionCount = value;
    notifyListeners();
  }

  // Expansion state setters
  set isExpandedBio(bool value) {
    _isExpandedBio = value;
    notifyListeners();
  }

  set isExpandedExperiences(bool value) {
    _isExpandedExperiences = value;
    notifyListeners();
  }

  set isExpandedEducation(bool value) {
    _isExpandedEducation = value;
    notifyListeners();
  }

  set isExpandedCertifications(bool value) {
    _isExpandedCertifications = value;
    notifyListeners();
  }

  set isExpandedSkills(bool value) {
    _isExpandedSkills = value;
    notifyListeners();
  }

  // Error state setters
  set experienceError(String? value) {
    _experienceError = value;
    notifyListeners();
  }

  set educationError(String? value) {
    _educationError = value;
    notifyListeners();
  }

  set skillError(String? value) {
    _skillError = value;
    notifyListeners();
  }

  set certificationError(String? value) {
    _certificationError = value;
    notifyListeners();
  }

  set bioError(String? value) {
    _bioError = value;
    notifyListeners();
  }

  set profileError(String? value) {
    _profileError = value;
    notifyListeners();
  }

  set resumeError(String? value) {
    _resumeError = value;
    notifyListeners();
  } // Add resumeError setter

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Expansion toggle methods
  void toggleBioExpansion() {
    _isExpandedBio = !_isExpandedBio;
    notifyListeners();
  }

  void toggleExperienceExpansion() {
    _isExpandedExperiences = !_isExpandedExperiences;
    notifyListeners();
  }

  void toggleEducationExpansion() {
    _isExpandedEducation = !_isExpandedEducation;
    notifyListeners();
  }

  void toggleCertificationExpansion() {
    _isExpandedCertifications = !_isExpandedCertifications;
    notifyListeners();
  }

  void toggleSkillsExpansion() {
    _isExpandedSkills = !_isExpandedSkills;
    notifyListeners();
  }

  // Profile methods
  Future<void> fetchProfile() async {
    _setLoading(true);
    _profileError = null;

    try {
      final result = await getProfileUseCase.call(NoParams());

      result.fold(
        (failure) {
          _profileError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (profile) {
          _userId = profile.userId;
          _name = profile.name;
          _profilePicture = profile.profilePicture;
          _coverPhoto = profile.coverPhoto;
          _resume = profile.resume;
          _headline = profile.headline;
          _bio = profile.bio;
          _location = profile.location;
          _industry = profile.industry;
          _skills = profile.skills;
          _educations = profile.education;
          _certifications = profile.certifications;
          _experiences = profile.experience;
          _visibility = profile.visibility;
          _connectionCount = profile.connectionCount;
          notifyListeners();
        },
      );
    } catch (e) {
      _profileError = "Unexpected error: ${e.toString()}";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Profile Picture methods
  Future<void> updateProfilePicture(String imageUrl) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateProfilePictureUseCase.call(imageUrl);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _profilePicture = imageUrl;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> deleteProfilePicture() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteProfilePictureUseCase.call(_userId ?? '');
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _profilePicture = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Cover Photo methods
  Future<void> updateCoverPhoto(String imageUrl) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateCoverPictureUseCase.call(imageUrl);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _coverPhoto = imageUrl;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> deleteCoverPhoto() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteCoverPhotoUseCase.call(_userId ?? '');
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _coverPhoto = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Headline methods
  Future<void> updateHeadline(String headline) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateHeadlineUseCase.call(headline);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _headline = headline;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Industry methods
  Future<void> updateIndustry(String industry) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateIndustryUseCase.call(industry);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _industry = industry;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Location methods
  Future<void> updateLocation(String location) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateLocationUseCase.call(location);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _location = location;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Name methods
  Future<void> updateName(String name) async {
    _setLoading(true);
    _profileError = null;

    final result = await updateNameUseCase.call(name);
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _name = name;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Resume methods
  Future<void> updateResume(String resumeUrl) async {
    _setLoading(true);
    _resumeError = null; // Clear previous resume errors

    final result = await updateResumeUseCase.call(resumeUrl);
    result.fold(
      (failure) {
        _resumeError = _mapFailureToMessage(
          failure,
        ); // Set resume-specific error
        notifyListeners();
      },
      (_) {
        _resume = resumeUrl;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Bio methods
  Future<void> setUserBio(String bio) async {
    _setLoading(true);
    _bioError = null;

    final result = await updateBioUseCase.call(bio);
    result.fold(
      (failure) {
        _bioError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _bio = bio;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Experience methods
  Future<void> addExperience(Experience experience) async {
    _setLoading(true);
    _experienceError = null;

    try {
      _experiences ??= [];
      _experiences!.add(experience);
      notifyListeners();

      final result = await addExperienceUseCase.call(experience);

      result.fold((failure) {
        _experiences!.remove(experience);
        _experienceError = _mapFailureToMessage(failure);
        notifyListeners();
      }, (_) {});
    } catch (e) {
      _experiences!.remove(experience);
      _experienceError = 'Unexpected error: ${e.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeExperience(int index) async {
    if (_experiences != null && index >= 0 && index < _experiences!.length) {
      _setLoading(true);
      _experienceError = null;

      final result = await deleteExperienceUseCase.call(
        _experiences![index].company,
      );
      result.fold(
        (failure) {
          _experienceError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          _experiences!.removeAt(index);
          notifyListeners();
        },
      );

      _setLoading(false);
    }
  }

  Future<void> updateExperience(
    Experience oldExperience,
    Experience newExperience,
  ) async {
    _setLoading(true);
    _experienceError = null;

    final result = await updateExperienceUseCase.call(newExperience);
    result.fold(
      (failure) {
        _experienceError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_experiences != null) {
          final index = _experiences!.indexWhere(
            (exp) =>
                exp.company == oldExperience.company &&
                exp.title == oldExperience.title,
          );
          if (index != -1) {
            _experiences![index] = newExperience;
            notifyListeners();
          }
        }
      },
    );

    _setLoading(false);
  }

  // Education methods
  Future<void> addEducation(Education education) async {
    _setLoading(true);
    _educationError = null;

    final result = await addEducationUseCase.call(education);
    result.fold(
      (failure) {
        _educationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _educations ??= [];
        _educations!.add(education);
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> removeEducation(int index) async {
    if (_educations != null && index >= 0 && index < _educations!.length) {
      _setLoading(true);
      _educationError = null;

      final result = await deleteEducationUseCase.call(
        _educations![index].school,
      );
      result.fold(
        (failure) {
          _educationError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          _educations!.removeAt(index);
          notifyListeners();
        },
      );

      _setLoading(false);
    }
  }

  Future<void> updateEducation(
    Education oldEducation,
    Education newEducation,
  ) async {
    _setLoading(true);
    _educationError = null;

    final result = await updateEducationUseCase.call(newEducation);
    result.fold(
      (failure) {
        _educationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_educations != null) {
          final index = _educations!.indexWhere(
            (edu) =>
                edu.school == oldEducation.school &&
                edu.degree == oldEducation.degree,
          );
          if (index != -1) {
            _educations![index] = newEducation;
            notifyListeners();
          }
        }
      },
    );

    _setLoading(false);
  }

  // Certification methods
  Future<void> addCertification(Certification certification) async {
    _setLoading(true);
    _certificationError = null;

    final result = await addCertificationUseCase.call(certification);
    result.fold(
      (failure) {
        _certificationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _certifications ??= [];
        _certifications!.add(certification);
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> removeCertification(int index) async {
    if (_certifications != null &&
        index >= 0 &&
        index < _certifications!.length) {
      _setLoading(true);
      _certificationError = null;

      final result = await deleteCertificationUseCase.call(
        _certifications![index].name,
      );
      result.fold(
        (failure) {
          _certificationError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          _certifications!.removeAt(index);
          notifyListeners();
        },
      );

      _setLoading(false);
    }
  }

  Future<void> updateCertification(
    Certification oldCertification,
    Certification newCertification,
  ) async {
    _setLoading(true);
    _certificationError = null;

    final result = await updateCertificationUseCase.call(newCertification);
    result.fold(
      (failure) {
        _certificationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_certifications != null) {
          final index = _certifications!.indexWhere(
            (cert) =>
                cert.name == oldCertification.name &&
                cert.issuingOrganization ==
                    oldCertification.issuingOrganization,
          );
          if (index != -1) {
            _certifications![index] = newCertification;
            notifyListeners();
          }
        }
      },
    );

    _setLoading(false);
  }

  // Skill methods
  Future<void> addSkill(Skill skill) async {
    _setLoading(true);
    _skillError = null;

    final result = await addSkillUseCase.call(skill);
    result.fold(
      (failure) {
        _skillError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _skills ??= [];
        _skills!.add(skill);
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> removeSkill(int index) async {
    if (_skills != null && index >= 0 && index < _skills!.length) {
      _setLoading(true);
      _skillError = null;

      final result = await deleteSkillUseCase.call(_skills![index].skill);
      result.fold(
        (failure) {
          _skillError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          _skills!.removeAt(index);
          notifyListeners();
        },
      );

      _setLoading(false);
    }
  }

  Future<void> updateSkill(Skill oldSkill, Skill newSkill) async {
    _setLoading(true);
    _skillError = null;

    final result = await updateSkillUseCase.call(newSkill);
    result.fold(
      (failure) {
        _skillError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_skills != null) {
          final index = _skills!.indexWhere((s) => s.skill == oldSkill.skill);
          if (index != -1) {
            _skills![index] = newSkill;
            notifyListeners();
          }
        }
      },
    );

    _setLoading(false);
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearErrors() {
    _experienceError = null;
    _educationError = null;
    _skillError = null;
    _certificationError = null;
    _bioError = null;
    _resumeError = null; // Include resumeError in clearErrors
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error occurred. Please try again later.';
      case NetworkFailure _:
        return 'Network error. Please check your connection.';
      case CacheFailure _:
        return 'Cache error. Please restart the app.';
      case ValidationFailure _:
        return 'Validation error: ${failure.message}';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
