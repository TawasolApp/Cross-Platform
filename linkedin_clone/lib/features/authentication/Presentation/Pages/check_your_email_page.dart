import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordCheckEmailPage extends StatelessWidget {
  const ForgotPasswordCheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Done", style: TextStyle(color: Colors.blue)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Image.asset(
              'assets/images/linkedin_logo.png',
              height: 28,
              color: isDark ? const Color(0xFFE5E5E5) : Colors.black,
            ),
            const SizedBox(height: 32),

            // Heading
            Text(
              "Check your email",
              style: linkedinTextTheme.displayLarge?.copyWith(
                fontSize: 24,
                color: isDark ? const Color(0xFFE5E5E5) : Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              "We sent a password reset link to $email.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? const Color(0xFFE5E5E5) : Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                // Trigger resend email logic
                
              },
              child: const Text("Resend email", style: TextStyle(color: Colors.blue)),
            ),

            const Spacer(),

            Text(
              "If you don’t see the email in your inbox, check your spam folder. If it’s not there, the email address may not be confirmed or may not match an existing LinkedIn account.",
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                // Handle email support
              },
              child: const Text(
                "Can’t access this email?",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
