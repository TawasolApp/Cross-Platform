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
import 'package:linkedin_clone/features/profile/presentation/widgets/resume_section.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    try {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();
      if (profileProvider.profileError != null) {
        setState(() => _error = profileProvider.profileError);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = "Error: ${e.toString()}");
        print("Profile loading error: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildPrivateProfileMessage(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(
              Icons.lock_outline,
              size: 40,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'This Profile is Private',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Connect with this member to view their full profile and professional journey.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Handle connect action
                    },
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Handle follow action
                    },
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = _isLoading || profileProvider.isLoading;

    // Use 'Owner' consistently (already correct in this file)
    final isOwner = profileProvider.status == 'Owner';
    final isConnection = profileProvider.status == 'Connection';
    final isPrivateProfile = profileProvider.visibility == 'private';
    final isConnectionsOnly = profileProvider.visibility == 'connections_only';
    final isPublicProfile = profileProvider.visibility == 'public';

    // Determine if we should show private profile message:
    // - If private profile AND NOT owner -> show private message
    // - If connections_only profile AND neither owner nor connection -> show private message
    // - If public OR if owner OR if connection with connections_only -> show full profile
    final showPrivateMessage =
        (isPrivateProfile && !isOwner) ||
        (isConnectionsOnly && !isOwner && !isConnection);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.main),
        ),
        title: Text(isOwner ? 'My Profile' : 'Profile'),
        actions: [
          if (isOwner) // Only show refresh for owner
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProfileData,
              tooltip: 'Refresh Profile',
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading profile: $_error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadProfileData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Always show profile header
                    Container(
                      color: Colors.white,
                      child: const ProfileHeader(),
                    ),
                    const SizedBox(height: 10),

                    // Show private profile message or content sections based on visibility rules
                    if (showPrivateMessage)
                      _buildPrivateProfileMessage(context)
                    else ...[
                      // Show all content sections ONLY if profile is not private
                      if (profileProvider.bio != null &&
                          profileProvider.bio!.trim().isNotEmpty)
                        Container(
                          color: Colors.white,
                          child: AboutSection(
                            bio: profileProvider.bio,
                            isExpanded: profileProvider.isExpandedBio,
                            onToggleExpansion:
                                profileProvider.toggleBioExpansion,
                            errorMessage: profileProvider.bioError,
                            isOwner: isOwner,
                          ),
                        ),
                      if (profileProvider.bio != null &&
                          profileProvider.bio!.trim().isNotEmpty)
                        const SizedBox(height: 10),

                      // Resume section (only visible to owner)
                      if (isOwner)
                        Container(
                          color: Colors.white,
                          child: ResumeSection(
                            resumeUrl: profileProvider.resume,
                            isCurrentUser: isOwner,
                            errorMessage: profileProvider.resumeError,
                          ),
                        ),
                      if (isOwner) const SizedBox(height: 10),

                      // Experience section
                      Container(
                        color: Colors.white,
                        child: ExperienceSection(
                          experiences: profileProvider.experiences,
                          isExpanded: profileProvider.isExpandedExperiences,
                          onToggleExpansion:
                              profileProvider.toggleExperienceExpansion,
                          errorMessage: profileProvider.experienceError,
                          isOwner: isOwner,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Education section
                      Container(
                        color: Colors.white,
                        child: EducationSection(
                          educations: profileProvider.educations,
                          isExpanded: profileProvider.isExpandedEducation,
                          onToggleExpansion:
                              profileProvider.toggleEducationExpansion,
                          errorMessage: profileProvider.educationError,
                          isOwner: isOwner,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Certifications section
                      Container(
                        color: Colors.white,
                        child: CertificationsSection(
                          certifications: profileProvider.certifications,
                          isExpanded: profileProvider.isExpandedCertifications,
                          onToggleExpansion:
                              profileProvider.toggleCertificationExpansion,
                          errorMessage: profileProvider.certificationError,
                          isOwner: isOwner,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Skills section
                      Container(
                        color: Colors.white,
                        child: SkillsSection(
                          skills: profileProvider.skills,
                          isExpanded: profileProvider.isExpandedSkills,
                          onToggleExpansion:
                              profileProvider.toggleSkillsExpansion,
                          errorMessage: profileProvider.skillError,
                          isOwner: isOwner,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
    );
  }
}
