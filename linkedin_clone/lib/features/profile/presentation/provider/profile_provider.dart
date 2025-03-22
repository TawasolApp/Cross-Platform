import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _userBio = '';
  List<Map<String, String>> _experiences = [];
  List<Map<String, String>> _educations = [];
  List<Map<String, String>> _certifications = [];
  List<String> _skills = [];
  bool _isExpandedExperiences = false;
  bool _isExpandedEducation = false;
  bool _isExpandedCertifications = false;

  // Getters
  String get userBio => _userBio;
  List<Map<String, String>> get experiences => _experiences;
  List<Map<String, String>> get educations => _educations;
  List<Map<String, String>> get certifications => _certifications;
  List<String> get skills => _skills;
  bool get isExpandedExperiences => _isExpandedExperiences;
  bool get isExpandedEducation => _isExpandedEducation;
  bool get isExpandedCertifications => _isExpandedCertifications;

  // Setters & Methods
  void setUserBio(String bio) {
    _userBio = bio;
    notifyListeners();
  }

  void addExperience(Map<String, String> experience) {
    _experiences.add(experience);
    notifyListeners();
  }

  void removeExperience(int index) {
    _experiences.removeAt(index);
    notifyListeners();
  }

  void toggleExperienceExpansion() {
    _isExpandedExperiences = !_isExpandedExperiences;
    notifyListeners();
  }

  void addEducation(Map<String, String> education) {
    _educations.add(education);
    notifyListeners();
  }

  void removeEducation(int index) {
    _educations.removeAt(index);
    notifyListeners();
  }

  void toggleEducationExpansion() {
    _isExpandedEducation = !_isExpandedEducation;
    notifyListeners();
  }

  void addCertification(Map<String, String> certification) {
    _certifications.add(certification);
    notifyListeners();
  }

  void removeCertification(int index) {
    _certifications.removeAt(index);
    notifyListeners();
  }

  void toggleCertificationExpansion() {
    _isExpandedCertifications = !_isExpandedCertifications;
    notifyListeners();
  }

  void addSkill(String skill) {
    _skills.add(skill);
    notifyListeners();
  }

  void removeSkill(int index) {
    _skills.removeAt(index);
    notifyListeners();
  }
}
