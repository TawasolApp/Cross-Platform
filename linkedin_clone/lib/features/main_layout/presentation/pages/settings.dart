import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.main),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Image and Name
          GestureDetector(
            onTap: () => context.go(RouteNames.profile),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Replace with user image
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
            title: const Text("Notifications"),
            onTap: () {
              // Navigate to Notifications Page
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
        ],
      ),
    );
  }
}
