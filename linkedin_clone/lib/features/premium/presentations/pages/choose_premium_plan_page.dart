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
      key: const Key('choose_premium_plan_scaffold'),
      appBar: AppBar(
        key: const Key('choose_premium_plan_app_bar'),
        surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: Text('', key: const Key('choose_premium_plan_app_bar_title')),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        leading: IconButton(
          key: const Key('choose_premium_plan_back_button'),
          icon: const Icon(
            Icons.arrow_back,
            key: Key('choose_premium_plan_back_icon'),
          ),
          onPressed: () => Navigator.pop(context),
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      body: SingleChildScrollView(
        key: const Key('choose_premium_plan_scroll_view'),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          key: const Key('choose_premium_plan_main_column'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: const Key('choose_premium_plan_text_1'),
              "unlock your 1-month free trial of LinkedIn Premium Career.",
              style: theme.titleLarge,
            ),
            const SizedBox(key: Key('choose_premium_plan_spacer_1'), height: 8),
            Text(
              key: const Key('choose_premium_plan_text_2'),
              "Cancel anytime before ${returnDateAfterDays(30)}. We'll send you a reminder 7 days before your free trial ends.",
              style: theme.bodySmall,
            ),
            SizedBox(
              key: const Key('choose_premium_plan_spacer_2'),
              height: pageHeight * 0.024,
            ),

            // Billing Cycle
            Text(
              key: const Key('choose_premium_plan_text_3'),
              "Confirm your billing cycle",
              style: theme.titleMedium,
            ),
            const SizedBox(key: Key('choose_premium_plan_spacer_3'), height: 8),
            Text(
              key: const Key('choose_premium_plan_text_4'),
              "Save EGP 9,263.136/year when you select Yearly billing cycle",
              style: theme.bodySmall,
            ),
            SizedBox(
              key: const Key('choose_premium_plan_spacer_4'),
              height: pageHeight * 0.012,
            ),
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

            SizedBox(
              key: const Key('choose_premium_plan_spacer_5'),
              height: pageHeight * 0.024,
            ),

            // Payment Type
            Text(
              key: const Key('choose_premium_plan_text_5'),
              "Select payment type",
              style: theme.titleMedium,
            ),
            SizedBox(
              key: const Key('choose_premium_plan_spacer_6'),
              height: pageHeight * 0.012,
            ),
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

            SizedBox(
              key: const Key('choose_premium_plan_spacer_7'),
              height: pageHeight * 0.024,
            ),

            // Order Summary
            Text(
              key: const Key('choose_premium_plan_text_6'),
              "Order summary",
              style: theme.titleMedium,
            ),
            SizedBox(
              key: const Key('choose_premium_plan_spacer_8'),
              height: pageHeight * 0.012,
            ),
            Container(
              key: const Key('choose_premium_plan_summary_container'),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                key: const Key('choose_premium_plan_summary_column'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: const Key('choose_premium_plan_text_7'),
                    " Premium Career (1 license, ${returnSubscriptionType(isYearly)} ) - 1-month free trial",
                    style: theme.bodyLarge,
                  ),
                  const SizedBox(
                    key: Key('choose_premium_plan_summary_spacer_1'),
                    height: 4,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_due_today_text'),
                    "EGP 0 due today",
                    style: theme.bodyMedium,
                  ),
                  SizedBox(
                    key: const Key('choose_premium_plan_summary_spacer_2'),
                    height: pageHeight * 0.012,
                  ),
                  Divider(
                    key: const Key('choose_premium_plan_summary_divider_1'),
                    color: Theme.of(context).dividerColor,
                  ),
                  SizedBox(
                    key: const Key('choose_premium_plan_summary_spacer_3'),
                    height: pageHeight * 0.012,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_after_trial_text'),
                    "After trial ends, on ${returnDateAfterDays(30)}:",
                    style: theme.bodySmall,
                  ),
                  const SizedBox(
                    key: Key('choose_premium_plan_summary_spacer_4'),
                    height: 6,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_first_license_text'),
                    "First license ${returnTotalBillingDetails(isYearly)}",
                    style: theme.bodySmall,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_amount_text'),
                    "EGP ${returnPaymentAmount(isYearly)}",
                    style: theme.bodyMedium,
                  ),
                  const SizedBox(
                    key: Key('choose_premium_plan_summary_spacer_5'),
                    height: 4,
                  ),
                  if (isYearly)
                    Text(
                      key: const Key('choose_premium_plan_discount_text'),
                      "Yearly discount (Save 16%)",
                      style: theme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 43, 130, 60),
                      ),
                    ),
                  if (isYearly)
                    Text(
                      key: const Key(
                        'choose_premium_plan_discount_amount_text',
                      ),
                      "EGP -9,263.136",
                      style: theme.bodyMedium?.copyWith(
                        color: const Color.fromARGB(255, 43, 130, 60),
                      ),
                    ),
                  const SizedBox(
                    key: Key('choose_premium_plan_summary_spacer_6'),
                    height: 8,
                  ),
                  Divider(
                    key: const Key('choose_premium_plan_summary_divider_2'),
                    color: Theme.of(context).dividerColor,
                  ),
                  const SizedBox(
                    key: Key('choose_premium_plan_summary_spacer_7'),
                    height: 8,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_total_label_text'),
                    "Total after free trial",
                    style: theme.bodySmall,
                  ),
                  Text(
                    key: const Key('choose_premium_plan_total_amount_text'),
                    returnPaymentAmount(isYearly),
                    style: theme.bodyMedium,
                  ),
                ],
              ),
            ),

            SizedBox(
              key: const Key('choose_premium_plan_spacer_9'),
              height: pageHeight * 0.024,
            ),
            Text(
              key: const Key('choose_premium_plan_reminder_text_1'),
              "Your free trial begins today and ends on ${returnDateAfterDays(30)}, We'll send you an email reminder 7 days before the trial ends.",
              style: theme.bodySmall,
            ),
            const SizedBox(
              key: Key('choose_premium_plan_spacer_10'),
              height: 8,
            ),
            Text(
              key: const Key('choose_premium_plan_reminder_text_2'),
              "Beginning${returnDateAfterDays(30)}, your payment method will be charged EGP . The plan will automatically renew yearly until canceled.\nCancel anytime before June 3, 2025 to avoid being charged.",
              style: theme.bodySmall,
            ),

            SizedBox(
              key: const Key('choose_premium_plan_spacer_11'),
              height: pageHeight * 0.024,
            ),
            SizedBox(
              key: const Key('choose_premium_plan_button_container'),
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('choose_premium_plan_button'),
                onPressed: () async {
                  String? checkoutUrl = await widget.premiumProvider
                      ?.subscribeToPremiumPlan(isYearly, isSubscription);
                  if (checkoutUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        key: const Key('choose_premium_plan_error_snackbar'),
                        content: Text(
                          'Failed to generate checkout URL. Please try again.',
                          key: const Key('choose_premium_plan_error_text'),
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
                          key: const Key(
                            'choose_premium_plan_success_snackbar',
                          ),
                          duration: const Duration(seconds: 2),
                          content: Text(
                            "Payment successful",
                            key: const Key('choose_premium_plan_success_text'),
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
                          key: const Key('choose_premium_plan_failed_snackbar'),
                          duration: const Duration(seconds: 2),
                          content: Text(
                            "Payment Failed,Please try again",
                            key: const Key('choose_premium_plan_failed_text'),
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
                child: Text(
                  key: const Key('choose_premium_plan_button_text'),
                  "Try now for EGP 0",
                  style: theme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(
              key: Key('choose_premium_plan_spacer_12'),
              height: 8,
            ),
            Center(
              key: const Key('choose_premium_plan_secure_checkout_center'),
              child: Text(
                key: const Key('choose_premium_plan_text_8'),
                "Secure checkout",
                style: theme.bodySmall,
              ),
            ),
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
    final String keyPrefix =
        value
            ? (value ? 'yearly' : 'monthly')
            : (groupValue ? 'subscription' : 'onetime');

    return GestureDetector(
      key: Key('choose_premium_plan_${keyPrefix}_option_gesture'),
      onTap: onTap,
      child: Container(
        key: Key('choose_premium_plan_${keyPrefix}_option_container'),
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
          key: Key('choose_premium_plan_${keyPrefix}_option_row'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              key: Key('choose_premium_plan_${keyPrefix}_option_icon'),
              groupValue ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  groupValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(
              key: Key('choose_premium_plan_radio_spacer'),
              width: 12,
            ),
            Expanded(
              key: Key('choose_premium_plan_${keyPrefix}_option_content'),
              child: Column(
                key: Key('choose_premium_plan_${keyPrefix}_option_column'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: Key('choose_premium_plan_text_9_${keyPrefix}'),
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(
                      key: Key('choose_premium_plan_subtitle_spacer'),
                      height: 4,
                    ),
                    Text(
                      key: Key('choose_premium_plan_text_10_${keyPrefix}'),
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

String returnSubscriptionType(bool isYearly) {
  if (isYearly) {
    return "Yearly";
  } else {
    return "Monthly";
  }
}

String returnPaymentAmountDetails(bool isYearly) {
  if (isYearly) {
    return "48,631.464 (plus applicable taxes) each year";
  } else {
    return "5,499.99 (plus applicable taxes) each month";
  }
}

String returnPaymentAmount(bool isYearly) {
  if (isYearly) {
    return "48,631.464";
  } else {
    return "5,499.99";
  }
}

String returnTotalBillingDetails(bool isYearly) {
  if (isYearly) {
    return "(EGP 4,824.5 x 12 months)";
  } else {
    return "(EGP 5,499.99 x 1 month)";
  }
}
