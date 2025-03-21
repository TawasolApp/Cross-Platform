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
  final String? headLine;
  final String? bio;
  final String? location;
  final String? industry;
  final List<Skill> skills;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Experience> experience;
  final String profileVisibility;

  const Profile({
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
