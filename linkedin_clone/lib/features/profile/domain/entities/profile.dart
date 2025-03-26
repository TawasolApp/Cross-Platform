import 'package:equatable/equatable.dart';
import 'skill.dart';
import 'education.dart';
import 'certification.dart';
import 'experience.dart';

class Profile extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final String? coverPhoto;
  final String? resume;
  final String? headline;
  final String? bio;
  final String? location;
  final String? industry;
  final List<Skill> skills;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Experience> experience;
  final String visibility;
  final int? connectionCount;
  // final PlanDetails? planDetails;
  // final PlanStatistics planStatistics;

  const Profile({
    required this.userId,
    required this.name,
    this.profilePicture,
    this.coverPhoto,
    this.resume,
    this.headline,
    this.bio,
    this.location,
    this.industry,
    this.skills = const [],
    this.education = const [],
    this.certifications = const [],
    this.experience = const [],
    this.visibility = "public",
    this.connectionCount,
    // this.planDetails,
    // required this.planStatistics,
  });

  Profile copyWith({
    String? userId,
    String? name,
    String? profilePicture,
    String? coverPhoto,
    String? resume,
    String? headline,
    String? bio,
    String? location,
    String? industry,
    List<Skill>? skills,
    List<Education>? education,
    List<Certification>? certifications,
    List<Experience>? experience,
    String? visibility,
    int? connectionCount,
  }) {
    return Profile(
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
