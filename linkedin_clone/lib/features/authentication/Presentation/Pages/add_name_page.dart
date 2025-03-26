// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';
import 'package:provider/provider.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final isDarkMode = theme.brightness == Brightness.dark;
    final provider = Provider.of<RegisterProvider>(context);

    String firstName = "";
    String lastName = "";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/linkedin_logo.png',
                height: 25,
                color: isDarkMode ? const Color(0xFFE5E5E5) : textColor,
              ),
              const SizedBox(height: 32),
              Text(
                "Add your name",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                keyboardType: TextInputType.name,
                hintText: "First Name",
                onChanged: provider.setFirstName,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                keyboardType: TextInputType.name,
                hintText: "Last Name",
                onChanged: provider.setLastName,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "Continue",
                onPressed: () {
                  if (provider.canContinueFromName) {
                    context.go(RouteNames.addEmail);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter both first and last name."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
