import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/themes/text_styles.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/add_name_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/login_error_modal.dart';
import 'package:linkedin_clone/features/authentication/presentation/widgets/primary_button.dart';
import 'package:linkedin_clone/features/authentication/presentation/widgets/social_login_buttons.dart';
import '../widgets/auth_footer.dart';
import '../../../../core/navigation/route_names.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo & Illustration
            Column(
              children: [
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/linkedin_logo.png',
                    height: 150, // Increased the height to make it bigger
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/onboarding_illustration.jpg',
                  height: 250,
                ),
                SizedBox(height: 20),
                Text(
                  "Find and land your next job",
                  style: linkedinTextTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    color:
                        isDarkMode
                            ? Color(0xFFE5E5E5)
                            : Color(0xFF191919), // Less gray, closer to white
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            // Buttons Section
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Ensures full-width buttons
              children: [
                PrimaryButton(
                  text: "Agree & Join",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AddNamePage(), // Replace with your target page
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildSocialButton(
                  context,
                  text: "Continue with Google",
                  icon: Icons.g_mobiledata,
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: signInWithGoogle,
                ),
                SizedBox(height: 20),
                AuthFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color buttonColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: BorderSide(color: Colors.grey.shade600),
          backgroundColor: buttonColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 24),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox();
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User cancelled
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
  }
}
