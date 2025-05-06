import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/main_layout/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class DeleteAccountPage extends StatelessWidget {
  final String userName;
  final String connectionName;
  final String connectionRole;
  final int connectionCount;

  const DeleteAccountPage({
    super.key,
    required this.userName,
    required this.connectionName,
    required this.connectionRole,
    required this.connectionCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final email = authProvider.email;
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Close account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.settings),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Help action
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message Text
              Text(
                "$userName, we're sorry to see you go",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Just a quick reminder, closing your account means you'll lose touch with your $connectionCount connections, like $connectionName.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You'll also lose any recommendations and endorsements you've given or received.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Password Input Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Connection Information
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/linkedin_logo.png'), // Replace with actual image
                ),
                title: Text(
                  connectionName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  connectionRole,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 24), // Replace Spacer with SizedBox

              // Continue Button
              Center(
                child: PrimaryButton(
                  text: "Save Changes",
                  onPressed: () async {
                    final password = passwordController.text.trim();
                    print("Deleting account for email: $email and password: $password");
                    final success = await settingsProvider.deleteAccount(email!, password);
                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account deleted successfully')),
                      );
                      authProvider.Logout(); // Log out the user after account deletion
                      context.go(RouteNames.onboarding);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete account')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
