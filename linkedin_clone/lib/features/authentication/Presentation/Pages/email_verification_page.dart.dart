import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/login_error_modal.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/presentation/widgets/primary_button.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;
    final authProvider = Provider.of<AuthProvider>(context);
    final registerProvider = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    final email = registerProvider.email;
    final password = registerProvider.password;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === BACK BUTTON (Arrow Only) ===
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color:
                      isDark
                          ? const Color(0xFFE5E5E5)
                          : const Color(0xFF191919),
                ),
              ),

              const SizedBox(height: 32),

              Image.asset(
                'assets/images/linkedin_logo.png',
                height: 120,
                color: isDark ? const Color(0xFFE5E5E5) : textColor,
              ),
              const SizedBox(height: 32),
              Text(
                'Check your email',
                style: linkedinTextTheme.displayLarge?.copyWith(
                  color:
                      isDark
                          ? const Color(0xFFE5E5E5)
                          : const Color(0xFF191919),
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to $email.\nClick the link to verify your email and continue.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDark
                          ? const Color(0xFFE5E5E5)
                          : const Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  // Trigger resend email
                  registerProvider.resendVerificationEmail(
                    email!,
                    "verifyEmail",
                  );

                  // Show a SnackBar to indicate the email has been resent
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Verification email has been resent.',
                      ),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
                child: PrimaryButton(
                  text: "Sign in",
                  onPressed: () async {
                    final success = await authProvider.login(email!, password!);
                    if (!context.mounted) return;

                    if (success) {
                      context.go(RouteNames.main);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder:
                            (context) => const CustomAuthErrorDialog(
                              message:
                                  "Please verify your email before continuing",
                            ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
