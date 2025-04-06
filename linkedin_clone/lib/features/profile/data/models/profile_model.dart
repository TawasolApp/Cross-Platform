import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';
import 'skill_model.dart';
import 'education_model.dart';
import 'certification_model.dart';
import 'experience_model.dart';

class ProfileModel extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String? coverPhoto;
  final String? resume;
  final String? headline;
  final String? bio;
  final String? location;
  final String? industry;
  final List<SkillModel> skills;
  final List<EducationModel> education;
  final List<CertificationModel> certification;
  final List<ExperienceModel> workExperience;
  final String visibility;
  final int? connectionCount;

  const ProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.coverPhoto,
    this.resume,
    this.headline,
    this.bio,
    this.location,
    this.industry,
    this.skills = const [],
    this.education = const [],
    this.certification = const [],
    this.workExperience = const [],
    this.visibility = "public",
    this.connectionCount,
  });

  // Convert to Entity
  Profile toEntity() {
    return Profile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      coverPhoto: coverPhoto,
      resume: resume,
      headline: headline,
      bio: bio,
      location: location,
      industry: industry,
      skills: skills.map((skill) => skill.toEntity()).toList(),
      education: education.map((edu) => edu.toEntity()).toList(),
      certification: certification.map((cert) => cert.toEntity()).toList(),
      workExperience: workExperience.map((exp) => exp.toEntity()).toList(),
      visibility: visibility,
      connectionCount: connectionCount,
    );
  }

  // Convert from Entity
  factory ProfileModel.fromEntity(Profile entity) {
    return ProfileModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      profilePicture: entity.profilePicture,
      coverPhoto: entity.coverPhoto,
      resume: entity.resume,
      headline: entity.headline,
      bio: entity.bio,
      location: entity.location,
      industry: entity.industry,
      skills:
          entity.skills.map((skill) => SkillModel.fromEntity(skill)).toList(),
      education:
          entity.education
              .map((edu) => EducationModel.fromEntity(edu))
              .toList(),
      certification:
          entity.certification
              .map((cert) => CertificationModel.fromEntity(cert))
              .toList(),
      workExperience:
          entity.workExperience
              .map((exp) => ExperienceModel.fromEntity(exp))
              .toList(),
      visibility: entity.visibility,
      connectionCount: entity.connectionCount,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String?,
      coverPhoto: json['coverPhoto'] as String?,
      resume: json['resume'] as String?,
      headline: json['headline'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      industry: json['industry'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      education:
          (json['education'] as List<dynamic>?)
              ?.map(
                (item) => EducationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      certification:
          (json['certification'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CertificationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      workExperience:
          (json['workExperience'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ExperienceModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      visibility: json['visibility'] as String? ?? "public",
      connectionCount: json['connection_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'coverPhoto': coverPhoto,
      'resume': resume,
      'headline': headline,
      'bio': bio,
      'location': location,
      'industry': industry,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'education': education.map((edu) => edu.toJson()).toList(),
      'certification': certification.map((cert) => cert.toJson()).toList(),
      'workExperience': workExperience.map((exp) => exp.toJson()).toList(),
      'visibility': visibility,
      'connection_count': connectionCount,
    };
  }

  ProfileModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? coverPhoto,
    String? resume,
    String? headline,
    String? bio,
    String? location,
    String? industry,
    List<SkillModel>? skills,
    List<EducationModel>? education,
    List<CertificationModel>? certification,
    List<ExperienceModel>? workExperience,
    String? visibility,
    int? connectionCount,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      resume: resume ?? this.resume,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      industry: industry ?? this.industry,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      certification: certification ?? this.certification,
      workExperience: workExperience ?? this.workExperience,
      visibility: visibility ?? this.visibility,
      connectionCount: connectionCount ?? this.connectionCount,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    profilePicture,
    coverPhoto,
    resume,
    headline,
    bio,
    location,
    industry,
    skills,
    education,
    certification,
    workExperience,
    visibility,
    connectionCount,
  ];
}
