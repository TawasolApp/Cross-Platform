import 'package:flutter/material.dart';

class PlanStatistics extends StatelessWidget {
  final int messagesSent;
  final int applicationsSubmitted;

  const PlanStatistics({
    super.key,
    required this.messagesSent,
    required this.applicationsSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plan Statistics',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {}, // Refresh statistics action
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Plan Statistics Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages Sent: $messagesSent',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Applications Submitted: $applicationsSubmitted',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
