import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/Provider/profile_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final regProvider = Provider.of<RegisterProvider>(context, listen: false);
    // final profileProvider = Provider.of<ProfileProvider>(
    //   context,
    //   listen: false,
    // );
    // profileProvider.fetchProfile("");
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Image and Name
          GestureDetector(
            onTap:
                () => context.go(
                  RouteNames.profile,
                  // extra: profileProvider.userId,
                ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    'assets/images/profile_placeholder.png',
                  ), // Replace with user image
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Omar Kaddah",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "Ex-SWE Intern @Dell Technologies",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sign in & Security
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Sign in & Security"),
            onTap: () {
              // Navigate to Sign in & Security Page
              context.go(RouteNames.signInAndSecurity);
            },
          ),

          // Visibility
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text("Visibility"),
            onTap: () {
              // Navigate to Visibility Page
            },
          ),

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Logout"),
            onTap: () {
              // Navigate to Logout Page
              authProvider.Logout();
              regProvider.reset();

              context.go(RouteNames.onboarding);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete Account"),
            onTap: () {
              // Navigate to Delete Account Page
              context.go(RouteNames.deleteAccount);
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text("Blocked Users"),
            onTap: () {
              // Navigate to Blocked Users Page
              goToBlocked(context);
            },
          ),
          // Admin Panel Access (only for Admins)
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text("Admin Panel"),
            onTap: () {
              // Navigate to Admin Panel Page
              context.push(RouteNames.adminPanel);
            },
          ),
        ],
      ),
    );
  }
}
