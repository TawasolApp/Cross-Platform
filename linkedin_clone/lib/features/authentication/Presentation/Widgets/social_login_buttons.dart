import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSocialButton("Continue with Apple", Icons.apple, Colors.black, Colors.white),
        SizedBox(height: 10),
        _buildSocialButton("Continue with Google", Icons.g_mobiledata, Colors.white, Colors.black),
      ],
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color buttonColor, Color textColor) {
    return SizedBox(
      width: double.infinity, // Ensures full-width buttons
      height: 48, // Match primary button height
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12), // Reduced padding for a thinner button
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // Reduced curve
          side: BorderSide(color: Colors.grey.shade600),
          backgroundColor: buttonColor,
          elevation: 0,
        ),
        onPressed: () {
          // Implement Google/Apple Sign-In Logic Here
        },
        icon: Icon(icon, color: textColor, size: 24),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
