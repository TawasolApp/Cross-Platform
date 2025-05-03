import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:linkedin_clone/features/premium/presentations/widgets/choices_card.dart';
import 'package:provider/provider.dart';

class PremiumSurveyCard extends StatefulWidget {
  final String question;
  final String subText;
  final List<String> options;

  PremiumSurveyCard({
    super.key,
    required this.question,
    required this.options,
    required this.subText,
  });

  @override
  State<PremiumSurveyCard> createState() => _PremiumSurveyCardState();
}

class _PremiumSurveyCardState extends State<PremiumSurveyCard> {
  late PremiumProvider premiumProvider;
  @override
  Widget build(BuildContext context) {
    premiumProvider = Provider.of<PremiumProvider>(context);
    return Column(
      key: const Key('key_premiumsurvey_main_column'),
      children: [
        Text(
          "${widget.question}?",
          key: const Key('key_premiumsurvey_question_text'),
          style: Theme.of(context).textTheme.titleLarge,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          key: const Key('key_premiumsurvey_question_spacer'),
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          key: const Key('key_premiumsurvey_subtext_row'),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.subText,
              key: const Key('key_premiumsurvey_subtext'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(
          key: const Key('key_premiumsurvey_choices_container'),
          height: MediaQuery.of(context).size.height * 0.6,
          child: ChoicesCard(
            key: const Key('key_premiumsurvey_choices_card'),
            choices: widget.options,
            type: ChoiceListType.premium,
          ),
        ),
      ],
    );
  }
}
