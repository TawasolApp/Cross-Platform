import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/login_error_modal.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/features/authentication/presentation/widgets/social_login_buttons.dart';
import 'package:linkedin_clone/features/authentication/presentation/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/linkedin_logo.png',
                    height: 25,
                    color: isDarkMode ? const Color(0xFFE5E5E5) : textColor,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode ? const Color(0xFFE5E5E5) : Colors.black,
                      size: 28,
                    ),
                    onPressed: () => context.go(RouteNames.onboarding),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                "Sign in",
                style: linkedinTextTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: isDarkMode ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 8),

              // Join Link
              Row(
                children: [
                  Text(
                    "or ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(RouteNames.register),
                    child: Text(
                      "Join LinkedIn",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // TextFields
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                hintText: "Email or Phone",
                isPassword: false,
                onChanged: (value) => email = value,
              
              ),
              const SizedBox(height: 16),
              CustomTextField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "Password",
                isPassword: true,
                onChanged: (value) => password = value,
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Future Forgot Password
                  },
                  child: Text(
                    "Forgot password?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Button
              PrimaryButton(
                text: "Sign in",
                onPressed: () async {
                  final success = await authProvider.login(email, password);
                  if (!context.mounted) return;

                  if (success) {
                    context.go(RouteNames.home);
                  } else {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => const CustomAuthErrorDialog(
                        message: "Wrong username or password",
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: theme.dividerColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or", style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: theme.dividerColor)),
                ],
              ),
              const SizedBox(height: 20),

              // Social Logins
              const SocialLoginButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
