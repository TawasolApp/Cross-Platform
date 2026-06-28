import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;
    Provider.of<RegisterProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Done" button (optional - back)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    "Done",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // LinkedIn Logo
              Image.asset(
                'assets/images/linkedin_logo.png',
                height: 25,
                color: isDark ? const Color(0xFFE5E5E5) : textColor,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                "Forgot password",
                style: linkedinTextTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 24),

              // Email / Phone field
              CustomTextField(
                hintText: "Email or Phone",
                isPassword: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // Handle change
                  authProvider.setEmail(value);
                },
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                "We’ll send a verification code to this email or phone number if it matches an existing LinkedIn account.",
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const Spacer(),

              // Submit Button
              PrimaryButton(
                text: "Next",
                onPressed: () {
                  // Handle forgot password logic
                  if (authProvider.email != null) {
                    
                    authProvider.forgotPassword(authProvider.email!);
                    context.go(RouteNames.checkemail);
                  } else {
                    // Handle the case where email is null
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email cannot be null")),
                    );
                  }
                
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
