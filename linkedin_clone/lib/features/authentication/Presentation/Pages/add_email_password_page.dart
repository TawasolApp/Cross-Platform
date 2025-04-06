import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/reacpctha_page.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/text_field.dart';

class AddEmailPasswordPage extends StatelessWidget {
  const AddEmailPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<RegisterProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => context.go(RouteNames.addName),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Image.asset(
                'assets/images/tawasol_logo.png', // Update with your logo
                height: 25,
                color: isDark ? const Color(0xFFE5E5E5) : theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(height: 32),
              Text(
                provider.showPasswordStep ? "Set your password" : "Add your email",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 24),

              // === EMAIL TEXT FIELD ===
              if (!provider.showPasswordStep)
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Email",
                  onChanged: provider.setEmail,
                  errorText: provider.emailError,
                ),

              // === PASSWORD TEXT FIELD ===
              if (provider.showPasswordStep) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Password",
                  isPassword: true,
                  onChanged: provider.setPassword,
                  errorText: provider.passwordError,
                ),
                const SizedBox(height: 8),
                Text(
                  "Password must be 6+ characters",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    Text(
                      "Remember me.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? const Color(0xFFE5E5E5) : const Color(0xFF191919),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Learn more action
                      },
                      child: Text(
                        "Learn more",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
              ],
              const SizedBox(height: 8),

              // === CONTINUE BUTTON ===
              PrimaryButton(
                text: provider.showPasswordStep ? "Register" : "Continue",
                onPressed: () async {
                  if (!provider.showPasswordStep) {
                    if (provider.isValidEmail) {
                      provider.showPasswordInput();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid email."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (provider.isValidPassword) {
                        // Proceed with registration
                        final email = provider.email;
                        final password = provider.password;
                        final firstName = provider.firstName;
                        final lastName = provider.lastName;

                        final success = await provider.register(
                          firstName!,
                          lastName!,
                          email!,
                          password!,
                          "test-token", 
                        );

                        if (!context.mounted) return;

                        if (success) {
                          context.go(RouteNames.verifyEmail);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registration failed.")),
                          );
                        }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password must be 6+ characters."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
