// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/utils/time_formatter.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/home_page.dart';
import 'package:linkedin_clone/features/premium/presentations/pages/premium_checkout_page.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChoosePremiumPlanPage extends StatefulWidget {
  PremiumProvider? premiumProvider;
  ChoosePremiumPlanPage({super.key});

  @override
  State<ChoosePremiumPlanPage> createState() => _ChoosePremiumPlanPageState();
}

class _ChoosePremiumPlanPageState extends State<ChoosePremiumPlanPage> {
  bool isYearly = true;
  bool isSubscription = true;

  @override
  Widget build(BuildContext context) {
    widget.premiumProvider = Provider.of<PremiumProvider>(context);
    final theme = Theme.of(context).textTheme;
    double pageHeight = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: Text(''),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "unlock your 1-month free trial of LinkedIn Premium Career.",
              style: theme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Cancel anytime before ${returnDateAfterDays(30)}. We'll send you a reminder 7 days before your free trial ends.",
              style: theme.bodySmall,
            ),
            SizedBox(height: pageHeight * 0.024),

            Text("Confirm your billing cycle", style: theme.titleMedium),
            const SizedBox(height: 8),
            Text(
              "Save EGP 9,263.136/year when you select Yearly billing cycle",
              style: theme.bodySmall,
            ),
            SizedBox(height: pageHeight * 0.012),
            buildRadioTile(
              "Monthly",
              "Includes 1 month free trial",
              false,
              isYearly == false,
              () {
                setState(() => isYearly = false);
              },
            ),
            buildRadioTile(
              "Yearly",
              "Includes 1 month free trial",
              true,
              isYearly == true,
              () {
                setState(() => isYearly = true);
              },
            ),

            SizedBox(height: pageHeight * 0.024),

            Text("Select payment type", style: theme.titleMedium),
            SizedBox(height: pageHeight * 0.012),
            buildRadioTile(
              "One-time Payment",
              null,
              false,
              isSubscription == false,
              () {
                setState(() => isSubscription = false);
              },
            ),
            buildRadioTile(
              "Subscription (Auto-renewal)",
              "Your payment method will be automatically charged at the end of each billing period.",
              true,
              isSubscription == true,
              () {
                setState(() => isSubscription = true);
              },
            ),

            SizedBox(height: pageHeight * 0.024),

            Text("Order summary", style: theme.titleMedium),
            SizedBox(height: pageHeight * 0.012),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Premium Career (1 license, ${returnSubscriptionType(isYearly)} ) - 1-month free trial",
                    style: theme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text("EGP 0 due today", style: theme.bodyMedium),
                  SizedBox(height: pageHeight * 0.012),
                  Divider(color: Theme.of(context).dividerColor),
                  SizedBox(height: pageHeight * 0.012),
                  Text(
                    "After trial ends, on ${returnDateAfterDays(30)}:",
                    style: theme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "First license ${returnTotalBillingDetails(isYearly)}",
                    style: theme.bodySmall,
                  ),
                  Text(
                    "EGP ${returnPaymentAmount(isYearly)}",
                    style: theme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  if (isYearly)
                    Text(
                      "Yearly discount (Save 16%)",
                      style: theme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 43, 130, 60),
                      ),
                    ),
                  if (isYearly)
                    Text(
                      "EGP -9,263.136",
                      style: theme.bodyMedium?.copyWith(
                        color: const Color.fromARGB(255, 43, 130, 60),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Divider(color: Theme.of(context).dividerColor),
                  const SizedBox(height: 8),
                  Text("Total after free trial", style: theme.bodySmall),
                  Text(returnPaymentAmount(isYearly), style: theme.bodyMedium),
                ],
              ),
            ),

            SizedBox(height: pageHeight * 0.024),
            Text(
              "Your free trial begins today and ends on ${returnDateAfterDays(30)}, We'll send you an email reminder 7 days before the trial ends.",
              style: theme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Beginning${returnDateAfterDays(30)}, your payment method will be charged EGP . The plan will automatically renew yearly until canceled.\nCancel anytime before June 3, 2025 to avoid being charged.",
              style: theme.bodySmall,
            ),

            SizedBox(height: pageHeight * 0.024),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String? checkoutUrl = await widget.premiumProvider
                      ?.subscribeToPremiumPlan(isYearly, isSubscription);
                  if (checkoutUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to generate checkout URL. Please try again.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PremiumCheckoutPage(checkoutUrl: checkoutUrl),
                    ),
                  );

                  if (result == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                    Future.delayed(Duration.zero, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                            "Payment successful",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    });
                  } else if (result == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                    Future.delayed(Duration.zero, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                            "Payment Failed,Please try again",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text("Try now for EGP 0", style: theme.bodyLarge),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text("Secure checkout", style: theme.bodySmall)),
          ],
        ),
      ),
    );
  }

  Widget buildRadioTile(
    String title,
    String? subtitle,
    bool value,
    bool groupValue,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                groupValue
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: groupValue ? Theme.of(context).colorScheme.onSecondary : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              groupValue ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  groupValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String returnSubscriptionType(bool isYearly) => isYearly ? "Yearly" : "Monthly";

String returnPaymentAmountDetails(bool isYearly) =>
    isYearly
        ? "48,631.464 (plus applicable taxes) each year"
        : "5,499.99 (plus applicable taxes) each month";

String returnPaymentAmount(bool isYearly) =>
    isYearly ? "48,631.464" : "5,499.99";

String returnTotalBillingDetails(bool isYearly) =>
    isYearly ? "(EGP 4,824.5 x 12 months)" : "(EGP 5,499.99 x 1 month)";
