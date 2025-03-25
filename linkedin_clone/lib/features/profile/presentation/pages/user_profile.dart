import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skills_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/about_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certifications_section.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE), // LinkedIn-like Background
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: profileProvider.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Profile Header**
              Container(
                color: Colors.white, 
                child: ProfileHeader(),
              ),
              const SizedBox(height: 10),

              // **About Section**
              if (profileProvider.bio != null && profileProvider.bio!.trim().isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  child: AboutSection(
                    provider: profileProvider,
                    bio: profileProvider.bio,
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // **Experience Section**
              Container(
                color: Colors.white, 
                child: ExperienceSection(
                  provider: profileProvider,
                  experiences: profileProvider.experiences,
                  isExpanded: profileProvider.isExpandedExperiences,
                  onToggleExpansion: profileProvider.toggleExperienceExpansion,
                  // onRemove: profileProvider.removeExperience(),
                  errorMessage: profileProvider.experienceError,
                ),
              ),
              const SizedBox(height: 10),

              // **Education Section**
              Container(
                color: Colors.white, 
                child: EducationSection(
                  provider: profileProvider,
                  educations: profileProvider.educations,
                  isExpanded: profileProvider.isExpandedEducation,
                  onToggleExpansion: profileProvider.toggleEducationExpansion,
                  // onRemove: profileProvider.removeEducation(),
                  errorMessage: profileProvider.educationError,
                ),
              ),
              const SizedBox(height: 10),

              // **Certifications Section**
              Container(
                color: Colors.white, 
                child: CertificationsSection(
                  provider: profileProvider,
                  certifications: profileProvider.certifications,
                  isExpanded: profileProvider.isExpandedCertifications,
                  onToggleExpansion: profileProvider.toggleCertificationExpansion,
                  // onRemove: profileProvider.removeCertification(),
                  errorMessage: profileProvider.certificationError,
                ),
              ),
              const SizedBox(height: 10),

              // **Skills Section**
              Container(
                color: Colors.white, 
                child: SkillsSection(
                  provider: profileProvider,
                  skills: profileProvider.skills,
                  isExpanded: profileProvider.isExpandedSkills,
                  onToggleExpansion: profileProvider.toggleSkillsExpansion,
                  // onRemove: profileProvider.removeSkill(),
                  errorMessage: profileProvider.skillError,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
