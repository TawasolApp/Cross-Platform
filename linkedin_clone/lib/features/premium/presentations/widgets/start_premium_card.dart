import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';

class StartPremiumCard extends StatelessWidget {
  const StartPremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: const ValueKey('start_premium_card_text_1'),
              "Achieve your goals faster with Premium.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              key: const ValueKey('start_premium_card_text_2'),
              "Millions of members use Premium",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              key: const ValueKey('start_premium_card_text_3'),
              "Claim your 1-month free trial today. Cancel anytime. "
              "We'll send you a reminder 7 days before your trial ends.",
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Text(
                key: const ValueKey('start_premium_card_text_4'),
                "Premium Plan Recommendation",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                key: const ValueKey('start_premium_card_text_5'),
                "Based on your selections, we recommend:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.012),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 141, 160, 184),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    key: const ValueKey('start_premium_card_text_6'),
                    "LinkedIn Premium Career",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    key: ValueKey('start_premium_card_text_7'),
                    "Best for job seekers and career growth",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Divider(thickness: 1, color: Theme.of(context).dividerColor),
            SizedBox(height: MediaQuery.of(context).size.height * 0.012),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Price: ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextSpan(
                    text: "EGP5,499.99 ",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  TextSpan(
                    text: "1-month free trial",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              key: ValueKey('start_premium_card_text_8'),
              "After your free month, pay as little as EGP4,599.00 / month (save 16%) "
              "when billed annually or pay EGP5,499.99 / month billed monthly  . Cancel anytime. We'll remind you 7 days before your trial ends.",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  goToChoosePremiumPlan(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  key: ValueKey('start_premium_card_button_text'),
                  "Start free trial",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                key: ValueKey('start_premium_card_text_9'),
                "Secure checkout",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
