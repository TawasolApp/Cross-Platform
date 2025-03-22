import 'package:flutter/material.dart';

class PlanDetails extends StatelessWidget {
  final String planName;
  final String expirationDate;
  final bool autoRenewal;

  const PlanDetails({
    super.key,
    required this.planName,
    required this.expirationDate,
    required this.autoRenewal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Subtle shadow
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plan Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {}, // Edit plan details action
                ),
              ],
            ),

            // Plan Details Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0), // Add some spacing
                Text(
                  'Plan: $planName',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0), // Add some spacing
                Text(
                  'Expires on: $expirationDate',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4.0), // Add some spacing
                Text(
                  'Auto-Renewal: ${autoRenewal ? "Enabled" : "Disabled"}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}