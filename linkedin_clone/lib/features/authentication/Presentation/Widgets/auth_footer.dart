import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_names.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Center(
      child: GestureDetector(
        onTap: (){
          GoRouter.of(context).go(RouteNames.login);
        },
        child: RichText(
          text: TextSpan(
            text: "Already on LinkedIn? ",
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            children: [
              TextSpan(
                text: "Sign in",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
