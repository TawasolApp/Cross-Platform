import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';
import 'skill_model.dart';
import 'education_model.dart';
import 'certification_model.dart';
import 'experience_model.dart';
// import 'plan_details_model.dart';
// import 'plan_statistics_model.dart';

class ProfileModel extends Profile with EquatableMixin {
  ProfileModel({
    required super.userId,
    required super.name,
    super.profilePicture,
    super.coverPhoto,
    super.resume,
    super.headline,
    super.bio,
    super.location,
    super.industry,
    super.skills = const [],
    super.education = const [],
    super.certifications = const [],
    super.experience = const [],
    super.visibility = "public",
    super.connectionCount,
    // super.planDetails,
    // required super.planStatistics,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      coverPhoto: json['cover_photo'] as String?,
      resume: json['resume'] as String?,
      headline: json['headline'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      industry: json['industry'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      education: (json['education'] as List<dynamic>?)
              ?.map((item) => EducationModel.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((item) => CertificationModel.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      experience: (json['experience'] as List<dynamic>?)
              ?.map((item) => ExperienceModel.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      visibility: json['visibility'] as String? ?? "public",
      connectionCount: json['connection_count'] as int?,
      // planDetails: json['plan_details'] != null
      //     ? PlanDetailsModel.fromJson(json['plan_details'] as Map<String, dynamic>)
      //     : null,
      // planStatistics: PlanStatisticsModel.fromJson(json['plan_statistics'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'profile_picture': profilePicture,
      'cover_photo': coverPhoto,
      'resume': resume,
      'headline': headline,
      'bio': bio,
      'location': location,
      'industry': industry,
      'skills': skills.map((skill) => (skill as SkillModel).toJson()).toList(),
      'education': education.map((edu) => (edu as EducationModel).toJson()).toList(),
      'certifications': certifications.map((cert) => (cert as CertificationModel).toJson()).toList(),
      'experience': experience.map((exp) => (exp as ExperienceModel).toJson()).toList(),
      'visibility': visibility,
      'connection_count': connectionCount,
      // 'plan_details': planDetails != null ? (planDetails as PlanDetailsModel).toJson() : null,
      // 'plan_statistics': (planStatistics as PlanStatisticsModel).toJson(),
    };
  }

  ProfileModel copyWith({
    String? userId,
    String? name,
    String? profilePicture,
    String? coverPhoto,
    String? resume,
    String? headline,
    String? bio,
    String? location,
    String? industry,
    List<SkillModel>? skills,
    List<EducationModel>? education,
    List<CertificationModel>? certifications,
    List<ExperienceModel>? experience,
    String? visibility,
    int? connectionCount,
    // PlanDetailsModel? planDetails,
    // PlanStatisticsModel? planStatistics,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      resume: resume ?? this.resume,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      industry: industry ?? this.industry,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      experience: experience ?? this.experience,
      visibility: visibility ?? this.visibility,
      connectionCount: connectionCount ?? this.connectionCount,
      // planDetails: planDetails ?? this.planDetails,
      // planStatistics: planStatistics ?? this.planStatistics,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        profilePicture,
        coverPhoto,
        resume,
        headline,
        bio,
        location,
        industry,
        skills,
        education,
        certifications,
        experience,
        visibility,
        connectionCount,
        // planDetails,
        // planStatistics,
      ];
}
