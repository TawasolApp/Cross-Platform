import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Widgets/login_error_modal.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSocialButton(
          context,
          text: "Continue with Apple",
          icon: Icons.apple,
          buttonColor: Colors.black,
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement Apple sign-in if needed
          },
        ),
        const SizedBox(height: 10),
        _buildSocialButton(
          context,
          text: "Continue with Google",
          icon: Icons.g_mobiledata, // You can replace this with Google logo asset
          buttonColor: Colors.white,
          textColor: Colors.black,
          onPressed: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final success = await authProvider.loginWithGoogle();

            if (!context.mounted) return;

            if (success) {
              context.go(RouteNames.home);
            } else {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) =>
                    const CustomAuthErrorDialog(message: "Google login failed"),
              );
            }
          },
        ),
      ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: BorderSide(color: Colors.grey.shade600),
          backgroundColor: buttonColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 24),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
