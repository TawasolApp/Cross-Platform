import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/forgot_password_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/main_layout/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _requireSignIn = true;

  void _showPasswordStrengthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF0073B1)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Choose a strong password to protect your account',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'It should be a mix of letters, numbers, and special characters\n\n'
                'It should be at least 8 characters long\n\n'
                'It should not contain your name, phone number, or email address',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.signInAndSecurity),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new password that is at least 8 characters long.',
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showPasswordStrengthDialog(context),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: Color(0xFF0073B1)),
                    SizedBox(width: 8),
                    Text(
                      'What makes a strong password?',
                      style: TextStyle(color: Color(0xFF0073B1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildPasswordField('Type your current password', _showCurrentPassword, (value) {
                setState(() {
                  _showCurrentPassword = value;
                });
              }, onChanged: settingsProvider.setCurrentPassword),
              const SizedBox(height: 10),
              _buildPasswordField('Type your new password', _showNewPassword, (value) {
                setState(() {
                  _showNewPassword = value;
                });
              }, onChanged: settingsProvider.setNewPassword),
              const SizedBox(height: 10),
              _buildPasswordField('Retype your new password', _showConfirmPassword, (value) {
                setState(() {
                  _showConfirmPassword = value;
                });
              }, onChanged: settingsProvider.setNewPassword),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text(
                  'Require all devices to sign in with the new password',
                ),
                value: _requireSignIn,
                onChanged: (value) {
                  setState(() {
                    _requireSignIn = value ?? true;
                  });
                },
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: "Save Changes",
                onPressed: () async {
                  final success = await settingsProvider.changePassword(
                    settingsProvider.currentPasswordValue,
                    settingsProvider.newPasswordValue,
                  );
                  if (!context.mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password updated successfully')),
                    );
                    context.go(RouteNames.signInAndSecurity);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update password: ${settingsProvider.errorMessage}')),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Color(0xFF0073B1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, bool showText, ValueChanged<bool> onToggle, {required ValueChanged<String> onChanged}) {
    return TextField(
      obscureText: !showText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hint,
        suffixIcon: GestureDetector(
          onTap: () => onToggle(!showText),
          child: Text(
            showText ? 'Hide' : 'Show',
            style: const TextStyle(color: Color(0xFF0073B1)),
          ),
        ),
      ),
    );
  }
}
