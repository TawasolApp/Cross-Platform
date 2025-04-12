import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/features/main_layout/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class UpdateEmailPage extends StatelessWidget {
  const UpdateEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final registerProvider = Provider.of<RegisterProvider>(
      context,
    ); // Define registerProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.signInAndSecurity),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update your email address'),
            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: 'New Email',
              onChanged:
                  settingsProvider.setEmail, // Directly update the provider
            ),
            const SizedBox(height: 10),
            CustomTextField(
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Password',
              isPassword: true,
              onChanged:
                  settingsProvider.setPassword, // Directly update the provider
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Save Changes",
              onPressed: () async {
                final success = await settingsProvider.updateEmail(
                  settingsProvider.newEmailValue,
                  settingsProvider.passwordValue,
                );

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check your email to confirm update'),
                    ),
                  );
                  context.go(RouteNames.signInAndSecurity);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to update email: ${settingsProvider.errorMessage}',
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive the email?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final success = await registerProvider
                        .resendVerificationEmail(
                          settingsProvider.newEmailValue,
                          "verifyEmail",
                        );

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Confirmation email resent successfully',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to resend email: ${settingsProvider.errorMessage}',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Resend Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
