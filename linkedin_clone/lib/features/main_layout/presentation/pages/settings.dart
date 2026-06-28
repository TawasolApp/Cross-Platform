// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:linkedin_clone/core/Navigation/route_names.dart';
// import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
// import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:linkedin_clone/features/profile/presentation/Provider/profile_provider.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final profileProvider = Provider.of<ProfileProvider>(
//         context,
//         listen: false,
//       );
//       profileProvider.fetchProfile("");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final authProvider = Provider.of<AuthProvider>(context);
//     final regProvider = Provider.of<RegisterProvider>(context, listen: false);
//     final profileProvider = Provider.of<ProfileProvider>(context);

//     return Scaffold(
//       body: ListView(
//         key: const Key('settingsListView'),
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Profile Image and Name
//           GestureDetector(
//             key: const Key('profileTile'),
//             onTap:
//                 () => context.go(
//                   RouteNames.profile,
//                   // extra: profileProvider.userId,
//                 ),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   key: Key('profileAvatar'),
//                   radius: 30,
//                   backgroundImage: AssetImage(
//                     'assets/images/profile_placeholder.png',
//                   ), // Replace with user image
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Omar Kaddah",
//                       key: const Key('profileNameText'),
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     Text(
//                       "Ex-SWE Intern @Dell Technologies",
//                       key: const Key('profileSubtitleText'),
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Sign in & Security
//           ListTile(
//             key: const Key('signInSecurityTile'),
//             leading: const Icon(Icons.lock),
//             title: const Text("Sign in & Security"),
//             onTap: () {
//               // Navigate to Sign in & Security Page
//               context.go(RouteNames.signInAndSecurity);
//             },
//           ),

//           // Visibility
//           ListTile(
//             key: const Key('visibilityTile'),
//             leading: const Icon(Icons.visibility),
//             title: const Text("Visibility"),
//             onTap: () {
//               // Navigate to Visibility Page
//             },
//           ),

//           // Notifications
//           ListTile(
//             key: const Key('logoutTile'),
//             leading: const Icon(Icons.notifications),
//             title: const Text("Logout"),
//             onTap: () {
//               // Navigate to Logout Page
//               authProvider.Logout();
//               regProvider.reset();

//               context.go(RouteNames.onboarding);
//             },
//           ),
//           ListTile(
//             key: const Key('deleteAccountTile'),
//             leading: const Icon(Icons.delete),
//             title: const Text("Delete Account"),
//             onTap: () {
//               // Navigate to Delete Account Page
//               context.go(RouteNames.deleteAccount);
//             },
//           ),
//           ListTile(
//             key: const Key('blockedUsersTile'),
//             leading: const Icon(Icons.block),
//             title: const Text("Blocked Users"),
//             onTap: () {
//               // Navigate to Admin Panel Page
//               context.push(RouteNames.adminPanel);
//             },
//           ),
//           // Admin Panel Access (only for Admins)
//           ListTile(
//             key: const Key('adminPanelTile'),
//             leading: const Icon(Icons.admin_panel_settings),
//             title: const Text("Admin Panel"),
//             onTap: () {
//               // Navigate to Admin Panel Page
//               context.push(RouteNames.adminPanel);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import 'package:provider/provider.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      profileProvider.fetchProfile("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final regProvider = Provider.of<RegisterProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context);

    final profilePicture = profileProvider.profilePicture;
    final fullName = profileProvider.fullName ?? 'Your Name';
    final headline = profileProvider.headline ?? '';

    return Scaffold(
      body: ListView(
        key: const Key('settingsListView'),
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Image and Name
          GestureDetector(
            key: const Key('profileTile'),
            onTap: () => context.go(RouteNames.profile),
            child: Row(
              children: [
                CircleAvatar(
                  key: const Key('profileAvatar'),
                  radius: 30,
                  backgroundImage:
                      profilePicture != null && profilePicture.isNotEmpty
                          ? NetworkImage(profilePicture)
                          : const AssetImage(
                                'assets/images/profile_placeholder.png',
                              )
                              as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      key: const Key('profileNameText'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      headline,
                      key: const Key('profileSubtitleText'),
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
            key: const Key('signInSecurityTile'),
            leading: const Icon(Icons.lock),
            title: const Text("Sign in & Security"),
            onTap: () => context.go(RouteNames.signInAndSecurity),
          ),

          // Visibility
          ListTile(
            key: const Key('visibilityTile'),
            leading: const Icon(Icons.visibility),
            title: const Text("Visibility"),
            onTap: () {
              // Navigate to Visibility Page
            },
          ),

          // Logout
          ListTile(
            key: const Key('logoutTile'),
            leading: const Icon(Icons.notifications),
            title: const Text("Logout"),
            onTap: () {
              authProvider.Logout();
              regProvider.reset();
              context.go(RouteNames.onboarding);
            },
          ),

          // Delete Account
          ListTile(
            key: const Key('deleteAccountTile'),
            leading: const Icon(Icons.delete),
            title: const Text("Delete Account"),
            onTap: () => context.go(RouteNames.deleteAccount),
          ),

          // Blocked Users
          ListTile(
            key: const Key('blockedUsersTile'),
            leading: const Icon(Icons.block),
            title: const Text("Blocked Users"),
            onTap: () {
              // Navigate to Blocked Users Page
              goToBlocked(context);
            },
          ),

          // // Admin Panel
          // ListTile(
          //   key: const Key('adminPanelTile'),
          //   leading: const Icon(Icons.admin_panel_settings),
          //   title: const Text("Admin Panel"),
          //   onTap: () => context.push(RouteNames.adminPanel),
          // ),
        ],
      ),
    );
  }
}
