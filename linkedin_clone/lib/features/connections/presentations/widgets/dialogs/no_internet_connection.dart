import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/buttons/linkedin_iconic_button.dart';

class NoInternetConnection extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetConnection({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 80,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
          SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Check your connection, then refresh the page.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 24),
          LinkedInIconicButton(label: "Refresh", onPressed: onRetry),
        ],
      ),
    );
  }
}
