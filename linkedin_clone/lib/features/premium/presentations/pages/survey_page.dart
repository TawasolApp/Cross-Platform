import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/buttons/linkedin_iconic_button.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/choices_card.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/premium_survey_card.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/start_premium_card.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  PremiumProvider? premiumProvider;
  List<String> quesitons = [
    "which of these best describes your primary goal for using Premium?",
    "how would you like Premium to help?",
    "You're 2.6x more likely to get hired with Premium. What is the key to you job search?",
  ];
  String subText = "We'll recommend the best plan for you";
  List<List<String>> options = [
    ["For my personal goals", "For my Job", "Other "],
    [
      "Find a job",
      "Learn professional skills",
      "Qrow my network or business",
      "Find leads",
      "Hire talent",
      "Other  ",
    ],
    [
      "See my profile views",
      "See jobs where I'm a top applicant",
      "Get resume help",
      "Stand out when I apply to jobs",
      "Allow recruiters to contact me",
      "Other   ",
    ],
  ];

  double progressValue = 0.2;
  String? selectedOption;
  bool firstPage = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            index = 0;
            progressValue = 0.2;
            firstPage = true;
            premiumProvider!.optionSelected = false;
            selectedOption = null;
            Navigator.pop(context);
          },
        ),
        actions: [
          if (progressValue < 0.8)
            TextButton(
              onPressed: () {
                setState(() {
                  progressValue = 0.8;
                });
              },
              child: Text(
                "Skip",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
        ],
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${(progressValue * 100).toInt()}%",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: progressValue,
              color: const Color.fromARGB(255, 43, 130, 60),
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "P R E M I U M",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            if (progressValue < 0.8)
              Consumer<PremiumProvider>(
                builder: (context, provider, _) {
                  return PremiumSurveyCard(
                    question: quesitons[index],
                    options: options[index],
                    subText: subText,
                  );
                },
              ),
            if (progressValue < 0.8) const Spacer(),
            if (progressValue < 0.8)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!firstPage)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = null;
                          premiumProvider!.optionSelected = false;
                          progressValue = progressValue - 0.2;
                          index--;
                          if (progressValue <= 0.2) {
                            progressValue = 0.2;
                            firstPage = true;
                          }
                        });
                      },
                      child: Text(
                        "Back",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  Consumer<PremiumProvider>(
                    builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed:
                              provider.optionSelected
                                  ? () {
                                    setState(() {
                                      firstPage = false;
                                      progressValue += 0.2;
                                      index++;
                                      selectedOption = null;
                                      provider.optionSelected = false;
                                    });
                                  }
                                  : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please select an option",
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (progressValue >= 0.8)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [StartPremiumCard()]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
