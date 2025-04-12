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
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart'; // Add this import
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart'; // Add this import

class UserProfile extends StatefulWidget {
  final String? userId;

  const UserProfile({super.key, this.userId});

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
      // Pass the widget's userId to fetchProfile
      await profileProvider.fetchProfile(widget.userId);
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
    final profileProvider = context.read<ProfileProvider>();
    final isFollowing = profileProvider.followStatus == 'Following';
    final isPending = profileProvider.connectStatus == 'Pending';
    final networksProvider = Provider.of<NetworksProvider>(
      context,
      listen: false,
    );

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
                      backgroundColor:
                          isPending
                              ? Colors.grey[200]
                              : Theme.of(context).primaryColor,
                      foregroundColor:
                          isPending ? Colors.black87 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final connectionsProvider =
                          Provider.of<ConnectionsProvider>(
                            context,
                            listen: false,
                          );

                      if (profileProvider.userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User ID is missing')),
                        );
                        return;
                      }

                      if (isPending) {
                        // If status is pending, show a confirmation dialog to withdraw
                        final shouldWithdraw = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text(
                                  'Withdraw Connection Request',
                                ),
                                content: const Text(
                                  'Are you sure you want to withdraw your connection request?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text(
                                      'WITHDRAW',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (shouldWithdraw == true) {
                          // Show loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Withdrawing connection request...',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );

                          // Call the withdraw connection request function
                          final success = await connectionsProvider
                              .withdrawConnectionRequest(
                                profileProvider.userId!,
                              );

                          // Show result
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Connection request withdrawn'
                                    : 'Failed to withdraw connection request',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );

                          // Refresh profile if successful
                          if (success) {
                            await profileProvider.fetchProfile(widget.userId);
                          }
                        }
                      } else {
                        // Status is not pending, send a new connection request
                        // Show loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sending connection request...'),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        // Send connection request
                        final success = await connectionsProvider
                            .sendConnectionRequest(profileProvider.userId!);

                        // Show result
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Connection request sent successfully'
                                  : 'Failed to send connection request',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );

                        // Refresh profile to get updated status
                        if (success) {
                          await profileProvider.fetchProfile(widget.userId);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isPending ? 'Pending' : 'Connect',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isPending) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.hourglass_top, size: 16),
                        ],
                      ],
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
                      backgroundColor:
                          isFollowing ? Colors.grey[200] : Colors.white,
                      foregroundColor:
                          isFollowing
                              ? Colors.black87
                              : Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color:
                              isFollowing
                                  ? Colors.transparent
                                  : Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      if (profileProvider.userId == null) return;

                      bool success;
                      if (isFollowing) {
                        // Unfollow action using NetworksProvider directly
                        success = await networksProvider.unfollowUser(
                          profileProvider.userId!,
                        );
                      } else {
                        // Follow action using NetworksProvider directly
                        success = await networksProvider.followUser(
                          profileProvider.userId!,
                        );
                      }

                      if (success) {
                        // Refresh profile to update UI state
                        await profileProvider.fetchProfile(widget.userId);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Unfollowed successfully'
                                  : 'Following successfully',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Failed to unfollow'
                                  : 'Failed to follow',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isFollowing) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check, size: 16),
                        ],
                      ],
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

  Widget _buildShowAllPostsButton(BuildContext context, String userId) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
            child: Text(
              "Activity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          OutlinedButton(
            onPressed: () {
              // Navigate to user posts page with the userId
              // context.push('${RouteNames.userPosts}/$userId');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              backgroundColor: Colors.white, // Background color
              side: BorderSide.none, // Remove border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 20, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Show all posts',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = _isLoading || profileProvider.isLoading;

    // Update status checks to use connectStatus and followStatus
    final isOwner = profileProvider.connectStatus == 'Owner';
    final isConnection = profileProvider.connectStatus == 'Connection';
    final isPrivateProfile = profileProvider.visibility == 'private';
    final isConnectionsOnly = profileProvider.visibility == 'connections_only';
    final isPublicProfile = profileProvider.visibility == 'public';

    // Determine if we should show private profile message:
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
              onPressed:
                  _loadProfileData, // This calls the fixed _loadProfileData method
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
                      Container(
                        color: Colors.white,
                        child: ResumeSection(
                          resumeUrl: profileProvider.resume,
                          isCurrentUser: isOwner,
                          errorMessage: profileProvider.resumeError,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Show All Posts button - add at the end
                      if (!showPrivateMessage && profileProvider.userId != null)
                        _buildShowAllPostsButton(
                          context,
                          profileProvider.userId!,
                        ),

                      const SizedBox(height: 10),

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
