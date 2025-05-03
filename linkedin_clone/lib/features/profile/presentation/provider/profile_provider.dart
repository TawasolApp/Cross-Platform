import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/core/api/media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/get_skill_endorsements.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_cover_photo.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_first_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_last_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_industry.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';

class ProfileProvider extends ChangeNotifier {
  // Use cases
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  final DeleteProfilePictureUseCase deleteProfilePictureUseCase;
  final UpdateCoverPictureUseCase updateCoverPictureUseCase;
  final DeleteCoverPhotoUseCase deleteCoverPhotoUseCase;
  final UpdateHeadlineUseCase updateHeadlineUseCase;
  final DeleteHeadlineUseCase deleteHeadlineUseCase;
  final UpdateIndustryUseCase updateIndustryUseCase;
  final DeleteIndustryUseCase deleteIndustryUseCase;
  final UpdateLocationUseCase updateLocationUseCase;
  final DeleteLocationUseCase deleteLocationUseCase;
  final UpdateFirstNameUseCase updateFirstNameUseCase;
  final UpdateLastNameUseCase updateLastNameUseCase;
  final UpdateResumeUseCase updateResumeUseCase;
  final DeleteResumeUseCase deleteResumeUseCase;
  final UpdateBioUseCase updateBioUseCase;
  final DeleteBioUseCase deleteBioUseCase;
  final AddExperienceUseCase addExperienceUseCase;
  final UpdateExperienceUseCase updateExperienceUseCase;
  final DeleteExperienceUseCase deleteExperienceUseCase;
  final AddSkillUseCase addSkillUseCase;
  final DeleteSkillUseCase deleteSkillUseCase;
  final AddEducationUseCase addEducationUseCase;
  final UpdateEducationUseCase updateEducationUseCase;
  final DeleteEducationUseCase deleteEducationUseCase;
  final AddCertificationUseCase addCertificationUseCase;
  final UpdateCertificationUseCase updateCertificationUseCase;
  final DeleteCertificationUseCase deleteCertificationUseCase;
  final UpdateSkillUseCase updateSkillUseCase;
  final GetSkillEndorsements getSkillEndorsementsUseCase;

  // Profile data
  String? _userId;
  String? _firstName;
  String? _lastName;
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
  String? _connectStatus; // Changed from _status
  String? _followStatus; // Added followStatus field

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
  String? _endorsementsError;
  List<Endorsement>? _currentEndorsements;
  bool _isLoadingEndorsements = false;
  bool _isLoading = false;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfilePictureUseCase,
    required this.deleteProfilePictureUseCase,
    required this.updateCoverPictureUseCase,
    required this.deleteCoverPhotoUseCase,
    required this.updateHeadlineUseCase,
    required this.deleteHeadlineUseCase,
    required this.updateIndustryUseCase,
    required this.deleteIndustryUseCase,
    required this.updateLocationUseCase,
    required this.deleteLocationUseCase,
    required this.updateFirstNameUseCase,
    required this.updateLastNameUseCase,
    required this.updateResumeUseCase,
    required this.deleteResumeUseCase,
    required this.updateBioUseCase,
    required this.deleteBioUseCase,
    required this.addExperienceUseCase,
    required this.updateExperienceUseCase,
    required this.deleteExperienceUseCase,
    required this.addEducationUseCase,
    required this.updateEducationUseCase,
    required this.deleteEducationUseCase,
    required this.addCertificationUseCase,
    required this.updateCertificationUseCase,
    required this.deleteCertificationUseCase,
    required this.updateSkillUseCase,
    required this.addSkillUseCase,
    required this.deleteSkillUseCase,
    required this.getSkillEndorsementsUseCase,
  });

  // Getters
  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String get fullName => "${_firstName ?? ''} ${_lastName ?? ''}".trim();
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
  String? get connectStatus => _connectStatus; // Changed from status
  String? get followStatus => _followStatus; // Added followStatus getter
  List<Endorsement>? get currentEndorsements => _currentEndorsements;
  String? get endorsementsError => _endorsementsError;
  bool get isLoadingEndorsements => _isLoadingEndorsements;

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

  set firstName(String? value) {
    _firstName = value;
    notifyListeners();
  }

  set lastName(String? value) {
    _lastName = value;
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

  set connectStatus(String? value) {
    _connectStatus = value;
    notifyListeners();
  }

  set followStatus(String? value) {
    _followStatus = value;
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

  // Profile Data Update Helper
  void _updateProfileData(dynamic profile) {
    if (profile == null) return;

    _userId = profile.userId;
    _firstName = profile.firstName;
    _lastName = profile.lastName;
    _profilePicture = profile.profilePicture;
    _coverPhoto = profile.coverPhoto;
    _resume = profile.resume;
    _headline = profile.headline;
    _bio = profile.bio;
    _location = profile.location;
    _industry = profile.industry;
    _skills = profile.skills;
    _educations = profile.education;
    _certifications = profile.certification;
    _experiences = profile.workExperience;
    _visibility = profile.visibility;
    _connectionCount = profile.connectionCount;
    _connectStatus = profile.connectStatus;
    _followStatus = profile.followStatus;

    // Add necessary null checks and notifyListeners
    notifyListeners();
  }

  // Profile methods
  Future<void> fetchProfile(String? userId) async {
    _setLoading(true);
    _profileError = null;

    try {
      // If userId is null or empty, fetch current user's profile
      final targetUserId = (userId != null && userId.isNotEmpty) ? userId : "";

      final result = await getProfileUseCase.call(targetUserId);

      result.fold(
        (failure) {
          _profileError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (profile) {
          _updateProfileData(profile);
          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      _profileError = "Unexpected error: ${e.toString()}";
      debugPrint("Profile fetch error: ${e.toString()}");
      debugPrint(stackTrace.toString());
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Profile Picture methods
  Future<void> updateProfilePicture(String imagePath) async {
    _setLoading(true);
    _profileError = null;

    try {
      // First upload the image using the media API
      final imageUrl = await uploadImage(XFile(imagePath));

      if (_userId == null) {
        _profileError = "User ID is not set";
        _setLoading(false);
        return;
      }

      // Then update the profile with the returned URL
      final result = await updateProfilePictureUseCase.call(
        ProfilePictureParams(userId: _userId!, profilePicture: imageUrl),
      );

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
    } catch (e) {
      _profileError = "Failed to upload image: ${e.toString()}";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProfilePicture() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteProfilePictureUseCase.call(NoParams());
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
  Future<void> updateCoverPhoto(String imagePath) async {
    _setLoading(true);
    _profileError = null;

    try {
      // First upload the image using the media API
      final imageUrl = await uploadImage(XFile(imagePath));

      if (_userId == null) {
        _profileError = "User ID is not set";
        _setLoading(false);
        return;
      }

      // Then update the profile with the returned URL
      final result = await updateCoverPictureUseCase.call(
        CoverPictureParams(userId: _userId!, coverPhoto: imageUrl),
      );

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
    } catch (e) {
      _profileError = "Failed to upload image: ${e.toString()}";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCoverPhoto() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteCoverPhotoUseCase.call(NoParams());
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

    if (_userId == null) {
      _profileError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateHeadlineUseCase.call(
      HeadlineParams(userId: _userId!, headline: headline),
    );

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

  Future<void> deleteHeadline() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteHeadlineUseCase.call(NoParams());
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _headline = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Industry methods
  Future<void> updateIndustry(String industry) async {
    _setLoading(true);
    _profileError = null;

    if (_userId == null) {
      _profileError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateIndustryUseCase.call(
      IndustryParams(userId: _userId!, industry: industry),
    );

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

  Future<void> deleteIndustry() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteIndustryUseCase.call(NoParams());
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _industry = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Location methods
  Future<void> updateLocation(String location) async {
    _setLoading(true);
    _profileError = null;

    if (_userId == null) {
      _profileError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateLocationUseCase.call(
      LocationParams(userId: _userId!, location: location),
    );

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

  Future<void> deleteLocation() async {
    _setLoading(true);
    _profileError = null;

    final result = await deleteLocationUseCase.call(NoParams());
    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _location = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // First Name methods
  Future<void> updateFirstName(String firstName) async {
    _setLoading(true);
    _profileError = null;

    if (_userId == null) {
      _profileError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateFirstNameUseCase.call(
      FirstNameParams(userId: _userId!, firstName: firstName),
    );

    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _firstName = firstName;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Last Name methods
  Future<void> updateLastName(String lastName) async {
    _setLoading(true);
    _profileError = null;

    if (_userId == null) {
      _profileError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateLastNameUseCase.call(
      LastNameParams(userId: _userId!, lastName: lastName),
    );

    result.fold(
      (failure) {
        _profileError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _lastName = lastName;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Resume methods
  Future<void> updateResume(String resumePath) async {
    _setLoading(true);
    _resumeError = null;

    try {
      // First upload the PDF using the media API
      final resumeUrl = await uploadImage(XFile(resumePath));
      

      if (_userId == null) {
        _resumeError = "User ID is not set";
        _setLoading(false);
        return;
      }

      // Then update the profile with the returned URL
      final result = await updateResumeUseCase.call(
        ResumeParams(userId: _userId!, resume: resumeUrl),
      );

      result.fold(
        (failure) {
          _resumeError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          _resume = resumeUrl;
          notifyListeners();
        },
      );
    } catch (e) {
      _resumeError = "Failed to upload resume: ${e.toString()}";
      notifyListeners();
    } finally {
      _setLoading(false);
    }

    _setLoading(false);
  }

  Future<void> deleteResume() async {
    _setLoading(true);
    _resumeError = null;

    final result = await deleteResumeUseCase.call(NoParams());
    result.fold(
      (failure) {
        _resumeError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _resume = null;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  // Bio methods
  Future<void> setUserBio(String bio) async {
    _setLoading(true);
    _bioError = null;

    if (_userId == null) {
      _bioError = "User ID is not set";
      _setLoading(false);
      return;
    }

    final result = await updateBioUseCase.call(
      BioParams(userId: _userId!, bio: bio),
    );

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

  Future<void> deleteBio() async {
    _setLoading(true);
    _bioError = null;

    final result = await deleteBioUseCase.call(NoParams());
    result.fold(
      (failure) {
        _bioError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _bio = null;
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

      final experienceId = _experiences![index].workExperienceId;
      if (experienceId == null) {
        _experienceError = "Experience ID is missing";
        _setLoading(false);
        return;
      }

      final result = await deleteExperienceUseCase.call(experienceId);
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

    final result = await updateExperienceUseCase.call(
      ExperienceUpdateParams(
        experienceId: oldExperience.workExperienceId ?? '',
        experience: newExperience,
      ),
    );

    result.fold(
      (failure) {
        _experienceError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_experiences != null) {
          final index = _experiences!.indexWhere(
            (exp) => exp.workExperienceId == oldExperience.workExperienceId,
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

      final educationId = _educations![index].educationId;
      if (educationId == null) {
        _educationError = "Education ID is missing";
        _setLoading(false);
        return;
      }

      final result = await deleteEducationUseCase.call(educationId);
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

    final result = await updateEducationUseCase.call(
      EducationUpdateParams(
        educationId: oldEducation.educationId ?? '',
        education: newEducation,
      ),
    );

    result.fold(
      (failure) {
        _educationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_educations != null) {
          final index = _educations!.indexWhere(
            (edu) => edu.educationId == oldEducation.educationId,
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

      final certificationId = _certifications![index].certificationId;
      if (certificationId == null) {
        _certificationError = "Certification ID is missing";
        _setLoading(false);
        return;
      }

      final result = await deleteCertificationUseCase.call(certificationId);
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

    final result = await updateCertificationUseCase.call(
      CertificationUpdateParams(
        certificationId: oldCertification.certificationId ?? '',
        certification: newCertification,
      ),
    );

    result.fold(
      (failure) {
        _certificationError = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        if (_certifications != null) {
          final index = _certifications!.indexWhere(
            (cert) => cert.certificationId == oldCertification.certificationId,
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

      final skillName = _skills![index].skillName;
      final result = await deleteSkillUseCase.call(skillName);

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

  // Add method for updating skill position
  Future<void> updateSkill(int index, Skill updatedSkill) async {
    if (_skills == null || index < 0 || index >= _skills!.length) {
      _skillError = "Invalid skill index";
      notifyListeners();
      return;
    }

    _setLoading(true);
    _skillError = null;

    try {
      final currentSkill = _skills![index];
      final skillName = currentSkill.skillName;

      // Use the proper use case for updating skills
      final result = await updateSkillUseCase.call(
        UpdateSkillParams(skillName: skillName, skill: updatedSkill),
      );

      result.fold(
        (failure) {
          _skillError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (_) {
          // Only position can change, skillName and endorsements stay the same
          _skills![index] = Skill(
            skillName: currentSkill.skillName,
            endorsements: currentSkill.endorsements,
            position: updatedSkill.position, // This can be null
          );
          notifyListeners();
        },
      );
    } catch (e) {
      _skillError = "Failed to update skill: ${e.toString()}";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Method to fetch endorsements for a specific skill
  Future<void> getSkillEndorsements(String skillName) async {
    if (_userId == null) {
      _endorsementsError = "User ID is not set";
      notifyListeners();
      return;
    }

    _isLoadingEndorsements = true;
    _endorsementsError = null;
    _currentEndorsements = null;
    notifyListeners();

    try {
      final params = GetSkillEndorsementsParams(
        userId: _userId!,
        skillName: skillName,
      );

      final result = await getSkillEndorsementsUseCase.call(params);

      result.fold(
        (failure) {
          _endorsementsError = _mapFailureToMessage(failure);
          notifyListeners();
        },
        (endorsements) {
          _currentEndorsements = endorsements;
          notifyListeners();
        },
      );
    } catch (e) {
      _endorsementsError = "Failed to fetch endorsements: ${e.toString()}";
      notifyListeners();
    } finally {
      _isLoadingEndorsements = false;
      notifyListeners();
    }
  }

  Future<bool> hasEndorsedSkill(String skillName) async {
  // Get the current user ID
  final currentUserId = await TokenService.getUserId();
  
  if (currentUserId == null) {
    return false;
  }

  // Check if we have the endorsements loaded for this skill
  if (_currentEndorsements != null) {
    return _currentEndorsements!.any((e) => e.userId == currentUserId);
  }

  // If endorsements aren't loaded, fetch them first
  try {
    _isLoadingEndorsements = true;
    notifyListeners();

    final params = GetSkillEndorsementsParams(
      userId: _userId!, // The profile we're viewing
      skillName: skillName,
    );

    final result = await getSkillEndorsementsUseCase.call(params);

    return result.fold(
      (failure) => false,
      (endorsements) {
        _currentEndorsements = endorsements;
        return endorsements.any((e) => e.userId == currentUserId);
      },
    );
  } catch (e) {
    debugPrint('Error checking endorsement: $e');
    return false;
  } finally {
    _isLoadingEndorsements = false;
    notifyListeners();
  }
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
    _endorsementsError = null;
    notifyListeners();
  }

  void clearEndorsementsError() {
    _endorsementsError = null;
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