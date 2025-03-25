import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';
import 'package:linkedin_clone/features/profile/data/repository/profile_repository_impl.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/get_experiences.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/get_skills.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/get_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/get_certifications.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/core/errors/failures.dart'; // Adjust the path as necessary
import 'package:linkedin_clone/core/errors/failures.dart' show ServerFailure, NetworkFailure, CacheFailure, ValidationFailure;

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final AddExperienceUseCase addExperienceUseCase;
  final UpdateExperienceUseCase updateExperienceUseCase;
  final DeleteExperienceUseCase deleteExperienceUseCase;
// final GetExperiencesUseCase getExperiencesUseCase;
  
  final AddSkillUseCase addSkillUseCase;
  final UpdateSkillUseCase updateSkillUseCase;
  final DeleteSkillUseCase deleteSkillUseCase;
// final GetSkillsUseCase getSkillsUseCase;
// final GetSkillsUseCase getSkillsUseCase;
  
  final AddEducationUseCase addEducationUseCase;
  final UpdateEducationUseCase updateEducationUseCase;
  final DeleteEducationUseCase deleteEducationUseCase;
// final GetEducationUseCase getEducationUseCase;
  
  final AddCertificationUseCase addCertificationUseCase;
  final UpdateCertificationUseCase updateCertificationUseCase;
  final DeleteCertificationUseCase deleteCertificationUseCase;
// final GetCertificationsUseCase getCertificationsUseCase;
  
  final UpdateBioUseCase updateBioUseCase;
  
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
  bool _isLoading = false;
  
  // Constructor with dependency injection
  ProfileProvider(
    this.getProfileUseCase,
    this.addExperienceUseCase,
    this.updateExperienceUseCase,
    this.deleteExperienceUseCase,
    this.addEducationUseCase,
    this.updateEducationUseCase,
    this.deleteEducationUseCase,
    this.addCertificationUseCase,
    this.updateCertificationUseCase,
    this.deleteCertificationUseCase,
    this.addSkillUseCase,
    this.updateSkillUseCase,
    this.deleteSkillUseCase,
    this.updateBioUseCase,
  );
  
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
  bool get isExpandedExperiences => _isExpandedExperiences;
  bool get isExpandedEducation => _isExpandedEducation;
  bool get isExpandedCertifications => _isExpandedCertifications;
  bool get isExpandedSkills=> _isExpandedSkills;

  // Additional getters for error states
  String? get experienceError => _experienceError;
  String? get educationError => _educationError;
  String? get skillError => _skillError; 
  String? get certificationError => _certificationError;
  String? get bioError => _bioError;
  String? get profileError => _profileError;
  bool get isLoading => _isLoading;

  // Setter for bio error
  set bioError(String? value) {
    _bioError = value;
    notifyListeners();
  }

  // Setters & Methods
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
      }
    );
    
    _setLoading(false);
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Clear all errors
  void clearErrors() {
    _experienceError = null;
    _educationError = null;
    _skillError = null;
    _certificationError = null;
    _bioError = null;
    notifyListeners();
  }

  Future<void> addExperience(Experience experience) async {
    _setLoading(true);
    _experienceError = null;
    
    try {
      // First add to local state for immediate UI update
      _experiences ??= [];
      _experiences!.add(experience);
      notifyListeners();

      // Then try to save to backend
      final result = await addExperienceUseCase.call(experience);
      
      result.fold(
        (failure) {
          // If backend fails, remove from local state
          _experiences!.remove(experience);
          _experienceError = _mapFailureToMessage(failure);
          notifyListeners();
        }, 
        (_) {
          // Success - no need to do anything as we already updated UI
        }
      );
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
      
      final result = await deleteExperienceUseCase.call(_experiences![index].company);
      result.fold(
        (failure) {
          _experienceError = _mapFailureToMessage(failure);
          notifyListeners();
        }, 
        (_) {
          _experiences!.removeAt(index);
          notifyListeners();
        }
      );
      
      _setLoading(false);
    }
  }

  Future<void> updateExperience(Experience oldExperience, Experience newExperience) async {
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
            (exp) => exp.company == oldExperience.company && exp.title == oldExperience.title);
          if (index != -1) {
            _experiences![index] = newExperience;
            notifyListeners();
          }
        }
      }
    );
    
    _setLoading(false);
  }

  void toggleExperienceExpansion() {
    _isExpandedExperiences = !_isExpandedExperiences;
    notifyListeners();
  }

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
      }
    );
    
    _setLoading(false);
  }

  Future<void> removeEducation(int index) async {
    if (_educations != null && index >= 0 && index < _educations!.length) {
      _setLoading(true);
      _educationError = null;
      
      final result = await deleteEducationUseCase.call(_educations![index].school);
      result.fold(
        (failure) {
          _educationError = _mapFailureToMessage(failure);
          notifyListeners();
        }, 
        (_) {
          _educations!.removeAt(index);
        }
      );
      
      _setLoading(false);
    }
  }

  Future<void> updateEducation(Education oldEducation, Education newEducation) async {
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
            (edu) => edu.school == oldEducation.school && edu.degree == oldEducation.degree);
          if (index != -1) {
            _educations![index] = newEducation;
          }
        }
      }
    );
    
    _setLoading(false);
  }

  void toggleEducationExpansion() {
    _isExpandedEducation = !_isExpandedEducation;
    notifyListeners();
  }

  Future<void> addCertification(Certification certification) async {
    final result = await addCertificationUseCase.call(certification);
    result.fold(
      (failure) => {/* Handle failure */}, 
      (_) {
        _certifications ??= [];
        _certifications!.add(certification);
        notifyListeners();
      }
    );
  }

  Future<void> removeCertification(int index) async {
    if (_certifications != null && index >= 0 && index < _certifications!.length) {
      await deleteCertificationUseCase.call(_certifications![index].name);
      _certifications?.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateCertification(Certification oldCertification, Certification newCertification) async {
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
            (cert) => cert.name == oldCertification.name && cert.issuingOrganization == oldCertification.issuingOrganization);
          if (index != -1) {
            _certifications![index] = newCertification;
          }
        }
      }
    );
    
    _setLoading(false);
  }

  void toggleCertificationExpansion() {
    _isExpandedCertifications = !_isExpandedCertifications;
    notifyListeners();
  }

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
      }
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
        }
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
          }
        }
      }
    );
    
    _setLoading(false);
  }

  void toggleSkillsExpansion() {
    _isExpandedSkills = !_isExpandedSkills;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _setLoading(true);
    _profileError = null;
    
    print("Fetching profile data...");
    
    try {
      final result = await getProfileUseCase.call(NoParams());  // Empty string as userId is not used in the implementation
      
      result.fold(
        (failure) {
          _profileError = _mapFailureToMessage(failure);
          print("Profile fetch error: $_profileError");
          notifyListeners();
        }, 
        (profile) {
          print("Profile fetched successfully");
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
        }
      );
    } catch (e) {
      _profileError = "Unexpected error: ${e.toString()}";
      print("Exception during profile fetch: $_profileError");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to convert failures to user-friendly messages
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
