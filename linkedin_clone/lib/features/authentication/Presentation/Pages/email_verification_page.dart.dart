import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;

    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    final email = registerProvider.email;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/linkedin_logo.png',
                height: 25,
                color: isDark ? const Color(0xFFE5E5E5) : textColor,
              ),
              const SizedBox(height: 32),
              Text(
                'Check your email',
                style: linkedinTextTheme.displayLarge?.copyWith(
                  color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to $email.\nClick the link to verify your email and continue.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  // Trigger resend email
                  registerProvider.resendVerificationEmail(email!);
                },
                child: Text(
                  'Resend verification email',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Check email verification status from backend if needed
                    context.go(RouteNames.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Continue", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
