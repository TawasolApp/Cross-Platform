import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skills_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/about_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certifications_section.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.fetchProfile();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
      print("Error loading profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    
    // Show local loading state or provider loading state
    bool isLoading = _isLoading || profileProvider.isLoading;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE), // LinkedIn-like Background
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfileData,
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error loading profile: $_error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfileData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
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
                              bio: profileProvider.bio,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // **Experience Section**
                        Container(
                          color: Colors.white, 
                          child: ExperienceSection(
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
