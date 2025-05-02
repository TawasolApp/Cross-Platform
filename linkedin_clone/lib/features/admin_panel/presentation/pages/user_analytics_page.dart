import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/admin_provider.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class UserAnalyticsPage extends StatefulWidget {
  const UserAnalyticsPage({super.key});

  @override
  State<UserAnalyticsPage> createState() => _UserAnalyticsPageState();
}

class _UserAnalyticsPageState extends State<UserAnalyticsPage> {
  final Map<String, Map<String, String>> _profileCache = {};
  Map<String, String>? _mostReportedProfile;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  void _fetchProfiles() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    // Fetch most reported user profile
    final mostReportedId = adminProvider.userAnalytics?.mostReportedUser;
    if (mostReportedId != null && mostReportedId.isNotEmpty) {
      await profileProvider.fetchProfile(mostReportedId);
      await Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        _mostReportedProfile = {
          'fullName': profileProvider.fullName ?? mostReportedId,
          'occupation': profileProvider.headline ?? '',
          'profilePicture': profileProvider.profilePicture ?? '',
          'userId': mostReportedId,
        };
      });
    }
    final userIds =
        adminProvider.userAnalytics?.mostActiveUsers.map((u) => u.userId) ?? [];

    for (final userId in userIds) {
      await profileProvider.fetchProfile(userId);

      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // give it time to populate

      setState(() {
        _profileCache[userId] = {
          'fullName': profileProvider.fullName ?? userId,
          'occupation': profileProvider.headline ?? '',
          'profilePicture': profileProvider.profilePicture ?? '',
        };
        print(
          "[Loaded] $userId → ${profileProvider.fullName}, ${profileProvider.headline}, ${profileProvider.profilePicture}",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AdminProvider>(context).userAnalytics;

    return Scaffold(
      appBar: AppBar(title: const Text("User Analytics")),
      body:
          user == null
              ? const Center(child: Text("No user analytics available."))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatCard(
                      title: "Total Users",
                      icon: Icons.people,
                      value: user.totalUsers.toString(),
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    // _buildStatCard(
                    //   title: "Most Reported User",
                    //   icon: Icons.warning_amber_rounded,
                    //   value: user.mostReportedUser,
                    //   color: Colors.redAccent,
                    //   subtitle: "Reported ${user.userReportedCount} times",
                    // ),
                    if (_mostReportedProfile != null)
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading:
                              _mostReportedProfile!['profilePicture']!
                                      .isNotEmpty
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      _mostReportedProfile!['profilePicture']!,
                                    ),
                                  )
                                  : const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                          title: Text(_mostReportedProfile!['fullName']!),
                          subtitle: Text(
                            _mostReportedProfile!['occupation'] ?? '',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),
                              Text(
                                "Reported ${user.userReportedCount} times",
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildStatCard(
                        title: "Most Reported User",
                        icon: Icons.warning_amber_rounded,
                        value: user.mostReportedUser,
                        color: Colors.redAccent,
                        subtitle: "Reported ${user.userReportedCount} times",
                      ),

                    const SizedBox(height: 24),
                    const Text(
                      "Most Active Users",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (user.mostActiveUsers.isNotEmpty)
                      ...user.mostActiveUsers.map((u) {
                        final profile = _profileCache[u.userId];
                        final fullName = profile?['fullName'] ?? u.userId;
                        final occupation = profile?['occupation'] ?? '';
                        final profilePicture = profile?['profilePicture'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading:
                                profilePicture.isNotEmpty
                                    ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        profilePicture,
                                      ),
                                    )
                                    : const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                            title: Text(fullName),
                            subtitle: Text(
                              occupation.isNotEmpty
                                  ? occupation
                                  : "Activity Score: ${u.activityScore}",
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Score: ${u.activityScore}",
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    else
                      const Text("No active users found."),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required String value,
    String? subtitle,
    Color color = Colors.blue,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(title, style: const TextStyle(fontSize: 14)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
