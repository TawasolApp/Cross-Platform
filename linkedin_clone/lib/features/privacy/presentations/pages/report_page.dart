// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/choices_card.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/premium_survey_card.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_enums.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_provider.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  String reportedId;
  ReportType reportType;

  ReportPage({super.key, required this.reportedId, required this.reportType});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Map<ReportType, List<String>> reportOptions = {
    ReportType.user: [
      "This person is impersonating someone",
      "This account has been hacked",
      "This account is fake",
      "Harassment or abusive behavior",
    ],
    ReportType.post: [
      "Harassment",
      "Fraud or scam",
      "Spam",
      "Misinformation",
      "Hateful speech",
      "Threats or violence",
      "Self-harm",
      "Graphic content",
      "Dangerous or extremist organizations",
      "Sexual content",
      "Fake account",
      "Child exploitation",
      "Illegal goods and services",
      "Infringement",
    ],
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('key_report_scaffold'),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        key: const Key('key_report_appbar'),
        leading: IconButton(
          key: const ValueKey('exit_report_page_button'),
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        key: const Key('key_report_body_padding'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          key: const Key('key_report_main_column'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(key: Key('key_report_spacer_1'), height: 20),
            Text(
              "Report ${widget.reportType.name}",
              key: const Key('key_report_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(key: Key('key_report_spacer_2'), height: 20),
            SizedBox(
              key: const Key('key_report_choices_container'),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ChoicesCard(
                key: const Key('key_report_choices_card'),
                choices: reportOptions[widget.reportType]!,
                type: ChoiceListType.report,
              ),
            ),
            const Spacer(key: Key('key_report_flex_spacer')),
            Consumer<PrivacyProvider>(
              key: const Key('key_report_privacy_consumer'),
              builder: (context, provider, child) {
                return Padding(
                  key: const Key('key_report_button_padding'),
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    key: const ValueKey('report_button'),
                    onPressed:
                        provider.reportReasonSelected!
                            ? () async {
                              bool result = false;
                              if (widget.reportType == ReportType.user) {
                                result = await provider.reportUser(
                                  widget.reportedId,
                                );
                              } else {
                                result = await provider.reportPost(
                                  widget.reportedId,
                                );
                              }
                              if (result) {
                                Navigator.pop(context);
                                Future.delayed(Duration.zero, () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      key: const Key(
                                        'key_report_success_snackbar',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                        "Report submitted successfully",
                                        key: const Key(
                                          'key_report_success_text',
                                        ),
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                        ),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );

                                  provider.reportReasonSelected = false;

                                  provider.reportReason = null;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    key: const Key(
                                      'key_report_failure_snackbar',
                                    ),
                                    content: Text(
                                      "Failed to submit report",
                                      key: const Key('key_report_failure_text'),
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              }
                            }
                            : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  key: const Key(
                                    'key_report_missing_reason_snackbar',
                                  ),
                                  content: Text(
                                    "Please choose a reason to report",
                                    key: const Key(
                                      'key_report_missing_reason_text',
                                    ),
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      "Report",
                      key: const Key('key_report_button_text'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(key: Key('key_report_spacer_3'), height: 20),
          ],
        ),
      ),
    );
  }
}
