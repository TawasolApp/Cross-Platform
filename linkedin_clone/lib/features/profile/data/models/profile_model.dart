import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'skill_model.dart';
import 'education_model.dart';
import 'certification_model.dart';
import 'experience_model.dart';

class ProfileModel extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final String? coverPhoto;
  final String? resume;
  final String? headLine;
  final String? bio;
  final String? location;
  final String? industry;
  final List<SkillModel> skills;
  final List<EducationModel> education;
  final List<CertificationModel> certifications;
  final List<ExperienceModel> experience;
  final String profileVisibility;

  const ProfileModel({
    required this.userId,
    required this.name,
    this.profilePicture,
    this.coverPhoto,
    this.resume,
    this.headLine,
    this.bio,
    this.location,
    this.industry,
    this.skills = const [],
    this.education = const [],
    this.certifications = const [],
    this.experience = const [],
    this.profileVisibility = "Public",
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String?,
      coverPhoto: json['coverPhoto'] as String?,
      resume: json['resume'] as String?,
      headLine: json['headLine'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      industry: json['industry'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      education: (json['education'] as List<dynamic>?)
              ?.map((item) => EducationModel.fromJson(item))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((item) => CertificationModel.fromJson(item))
              .toList() ??
          [],
      experience: (json['experience'] as List<dynamic>?)
              ?.map((item) => ExperienceModel.fromJson(item))
              .toList() ??
          [],
      profileVisibility: json['profileVisibility'] as String? ?? "Public",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profilePicture': profilePicture,
      'coverPhoto': coverPhoto,
      'resume': resume,
      'headLine': headLine,
      'bio': bio,
      'location': location,
      'industry': industry,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'education': education.map((edu) => edu.toJson()).toList(),
      'certifications': certifications.map((cert) => cert.toJson()).toList(),
      'experience': experience.map((exp) => exp.toJson()).toList(),
      'profileVisibility': profileVisibility,
    };
  }

  /// Converts `ProfileModel` to `Profile` entity.
  Profile toEntity() {
    return Profile(
      userId: userId,
      name: name,
      profilePicture: profilePicture,
      coverPhoto: coverPhoto,
      resume: resume,
      headLine: headLine,
      bio: bio,
      location: location,
      industry: industry,
      skills: skills.map((skill) => skill.toEntity()).toList(),
      education: education.map((edu) => edu.toEntity()).toList(),
      certifications: certifications.map((cert) => cert.toEntity()).toList(),
      experience: experience.map((exp) => exp.toEntity()).toList(),
      profileVisibility: profileVisibility,
    );
  }

  /// Converts `Profile` entity to `ProfileModel`
  factory ProfileModel.fromEntity(Profile entity) {
    return ProfileModel(
      userId: entity.userId,
      name: entity.name,
      profilePicture: entity.profilePicture,
      coverPhoto: entity.coverPhoto,
      resume: entity.resume,
      headLine: entity.headLine,
      bio: entity.bio,
      location: entity.location,
      industry: entity.industry,
      skills: entity.skills.map((skill) => SkillModel.fromEntity(skill)).toList(),
      education: entity.education.map((edu) => EducationModel.fromEntity(edu)).toList(),
      certifications: entity.certifications.map((cert) => CertificationModel.fromEntity(cert)).toList(),
      experience: entity.experience.map((exp) => ExperienceModel.fromEntity(exp)).toList(),
      profileVisibility: entity.profileVisibility,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        profilePicture,
        coverPhoto,
        resume,
        headLine,
        bio,
        location,
        industry,
        skills,
        education,
        certifications,
        experience,
        profileVisibility,
      ];
}
