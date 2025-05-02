import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  ProfileProvider? profileProvider;
  String? firstName;
  double progressValue = 0;
  String? selectedOption;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider!.fetchProfile("");
      firstName = profileProvider!.firstName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              //TODO: implement skip functionality
            },
            child: Text("Skip", style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progressValue,
              color: const Color.fromARGB(255, 43, 130, 60),
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(height: 20),
            Text(
              "P R E M I U M",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              "$firstName, which of these best describes your primary goal for using Premium?",
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              "We’ll recommend the right plan for you.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 30),
            CheckboxListTile(
              title: const Text("For my personal goals"),
              value: selectedOption == "personal",
              onChanged: (val) {
                setState(() {
                  selectedOption = "personal";
                });
              },
            ),
            CheckboxListTile(
              title: const Text("For my job"),
              value: selectedOption == "job",
              onChanged: (val) {
                setState(() {
                  selectedOption = "job";
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Other"),
              value: selectedOption == "other",
              onChanged: (val) {
                setState(() {
                  selectedOption = "other";
                });
              },
            ),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: []),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
