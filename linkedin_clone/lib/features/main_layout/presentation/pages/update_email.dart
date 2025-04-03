import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/features/main_layout/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class UpdateEmailPage extends StatelessWidget {
  const UpdateEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String currentEmail = '';
    String newEmail = '';
    String password = '';
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update your email address'),
            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Current Email',
              onChanged: (value) => currentEmail = value,
            ),
            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: 'New Email',
              onChanged: (value) => newEmail = value,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Password',
              isPassword: true,
              onChanged: (value) => password = value,
            ),
            const SizedBox(height: 20),
              PrimaryButton(
                text: "Save Changes",
                onPressed: () async {
                  final success = await settingsProvider.updateEmail(newEmail, password);
                  if (!context.mounted) return;

                  if (success) {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email updated successfully')),
                    );
                    //context.go(RouteNames.signInAndSecurity);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update email')),
                    );
                  } 
                },
              ),
          ],
        ),
      ),
    );
  }


  
}
