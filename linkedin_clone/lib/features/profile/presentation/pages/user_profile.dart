import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
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
    // ✅ Wait until widget is built before accessing provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    try {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = _isLoading || profileProvider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go(RouteNames.main); // Return to previous screen
            },
          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(color: Colors.white, child: ProfileHeader()),
                      const SizedBox(height: 10),
                      if (profileProvider.bio != null && profileProvider.bio!.trim().isNotEmpty)
                        ...[
                          Container(
                            color: Colors.white,
                            child: AboutSection(bio: profileProvider.bio),
                          ),
                          const SizedBox(height: 10),
                        ],
                      Container(
                        color: Colors.white,
                        child: ExperienceSection(
                          experiences: profileProvider.experiences,
                          isExpanded: profileProvider.isExpandedExperiences,
                          onToggleExpansion: profileProvider.toggleExperienceExpansion,
                          errorMessage: profileProvider.experienceError,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: EducationSection(
                          educations: profileProvider.educations,
                          isExpanded: profileProvider.isExpandedEducation,
                          onToggleExpansion: profileProvider.toggleEducationExpansion,
                          errorMessage: profileProvider.educationError,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: Expanded(
                          child: CertificationsSection(
                            certifications: profileProvider.certifications,
                            isExpanded: profileProvider.isExpandedCertifications,
                            onToggleExpansion: profileProvider.toggleCertificationExpansion,
                            errorMessage: profileProvider.certificationError,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: Expanded(
                          child: SkillsSection(
                            skills: profileProvider.skills,
                            isExpanded: profileProvider.isExpandedSkills,
                            onToggleExpansion: profileProvider.toggleSkillsExpansion,
                            errorMessage: profileProvider.skillError,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
    );
  }
}
