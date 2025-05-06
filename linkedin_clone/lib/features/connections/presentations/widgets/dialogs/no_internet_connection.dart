import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/buttons/linkedin_iconic_button.dart';

class NoInternetConnection extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetConnection({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('key_nointernet_center'),
      child: Column(
        key: const Key('key_nointernet_column'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            key: const Key('key_nointernet_icon'),
            Icons.wifi_off,
            size: 80,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
          SizedBox(key: const Key('key_nointernet_spacer1'), height: 16),
          Text(
            'No Internet Connection',
            key: const Key('key_nointernet_title_text'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(key: const Key('key_nointernet_spacer2'), height: 8),
          Text(
            'Check your connection, then refresh the page.',
            key: const Key('key_nointernet_message_text'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(key: const Key('key_nointernet_spacer3'), height: 24),
          LinkedInIconicButton(
            key: const Key('key_nointernet_refresh_button'),
            label: "Refresh",
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
