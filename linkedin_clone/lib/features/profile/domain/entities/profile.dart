import 'package:equatable/equatable.dart';
import 'skill.dart';
import 'education.dart';
import 'certification.dart';
import 'experience.dart';

class Profile extends Equatable {
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
  final List<Skill> skills;
  final List<Education> education;
  final List<Certification> certification;
  final List<Experience> workExperience;
  final String visibility;
  final int? connectionCount;

  const Profile({
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

  // Get full name
  String get fullName => "$firstName $lastName";

  Profile copyWith({
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
    List<Skill>? skills,
    List<Education>? education,
    List<Certification>? certification,
    List<Experience>? workExperience,
    String? visibility,
    int? connectionCount,
  }) {
    return Profile(
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
