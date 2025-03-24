import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final isDarkMode = theme.brightness == Brightness.dark;

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
                onChanged: (value) {
                  firstName = value;
                },
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                keyboardType: TextInputType.name,
                hintText: "Last Name",
                onChanged: (value) {
                  lastName = value;
                },
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "Continue",
                onPressed: () {
                  context.go(RouteNames.addEmail);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
