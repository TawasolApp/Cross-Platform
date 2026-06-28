import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';

class StartPremiumCard extends StatelessWidget {
  const StartPremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('key_startpremium_card'),
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        key: const Key('key_startpremium_padding'),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          key: const Key('key_startpremium_column'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: const Key('key_startpremium_title_text'),
              "Achieve your goals faster with Premium.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(key: Key('key_startpremium_spacer1'), height: 8),
            Text(
              key: const Key('key_startpremium_subtitle_text'),
              "Millions of members use Premium",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(key: Key('key_startpremium_spacer2'), height: 8),
            Text(
              key: const Key('key_startpremium_description_text'),
              "Claim your 1-month free trial today. Cancel anytime. "
              "We'll send you a reminder 7 days before your trial ends.",
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              key: const Key('key_startpremium_spacer3'),
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              key: const Key('key_startpremium_heading_center'),
              child: Text(
                key: const Key('key_startpremium_heading_text'),
                "Premium Plan Recommendation",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(key: Key('key_startpremium_spacer4'), height: 8),
            Center(
              key: const Key('key_startpremium_subheading_center'),
              child: Text(
                key: const Key('key_startpremium_subheading_text'),
                "Based on your selections, we recommend:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(
              key: const Key('key_startpremium_spacer5'),
              height: MediaQuery.of(context).size.height * 0.012,
            ),
            Container(
              key: const Key('key_startpremium_plan_container'),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 141, 160, 184),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                key: const Key('key_startpremium_plan_column'),
                children: [
                  Text(
                    key: const Key('key_startpremium_plan_title_text'),
                    "LinkedIn Premium Career",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    key: Key('key_startpremium_plan_spacer'),
                    height: 4,
                  ),
                  Text(
                    key: const Key('key_startpremium_plan_subtitle_text'),
                    "Best for job seekers and career growth",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(
              key: const Key('key_startpremium_spacer6'),
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Divider(
              key: const Key('key_startpremium_divider'),
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
            SizedBox(
              key: const Key('key_startpremium_spacer7'),
              height: MediaQuery.of(context).size.height * 0.012,
            ),
            Text.rich(
              key: const Key('key_startpremium_price_text'),
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
            const SizedBox(key: Key('key_startpremium_spacer8'), height: 8),
            Text(
              key: const Key('key_startpremium_terms_text'),
              "After your free month, pay as little as EGP4,599.00 / month (save 16%) "
              "when billed annually or pay EGP5,499.99 / month billed monthly  . Cancel anytime. We'll remind you 7 days before your trial ends.",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              key: const Key('key_startpremium_spacer9'),
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              key: const Key('key_startpremium_button_container'),
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('key_startpremium_trial_button'),
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
                  key: const Key('key_startpremium_button_text'),
                  "Start free trial",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(key: Key('key_startpremium_spacer10'), height: 8),
            Center(
              key: const Key('key_startpremium_secure_center'),
              child: Text(
                key: const Key('key_startpremium_secure_text'),
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
