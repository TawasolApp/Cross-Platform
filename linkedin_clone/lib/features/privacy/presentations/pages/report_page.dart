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
      "Harassment or abusive behavior",
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
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('exit_report_page_button'),
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Report ${widget.reportType.name}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ChoicesCard(
                choices: reportOptions[widget.reportType]!,
                type: ChoiceListType.report,
              ),
            ),
            const Spacer(),
            Consumer<PrivacyProvider>(
              builder: (context, provider, child) {
                return Padding(
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
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                        "Report submitted successfully",
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
                                    content: Text(
                                      "Failed to submit report",
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
                                  content: Text(
                                    "Please choose a reason to report",
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
