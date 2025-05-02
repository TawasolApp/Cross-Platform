import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChoicesCard extends StatefulWidget {
  List<String>? choices;
  ChoiceListType? type;
  PrivacyProvider? privacyProvider;
  PremiumProvider? premiumProvider;
  ChoicesCard({super.key, this.choices, this.type});

  @override
  State<ChoicesCard> createState() => _ChoicesCardState();
}

class _ChoicesCardState extends State<ChoicesCard> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    if (widget.type == ChoiceListType.premium) {
      widget.premiumProvider = Provider.of<PremiumProvider>(context);
      widget.privacyProvider = null;
    } else {
      widget.premiumProvider = null;
      widget.privacyProvider = Provider.of<PrivacyProvider>(context);
    }

    return ListView.builder(
      itemCount: widget.choices?.length ?? 0,
      itemBuilder: (context, index) {
        return Column(
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                widget.choices?[index] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: selectedOption == widget.choices?[index],
              checkColor: Theme.of(context).colorScheme.onSecondary,
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return const Color.fromARGB(255, 43, 130, 60);
                }
                return Theme.of(context).colorScheme.onSecondary;
              }),
              onChanged: (val) {
                setState(() {
                  if (widget.type == ChoiceListType.premium) {
                    selectedOption = widget.choices?[index] ?? '';
                    widget.premiumProvider?.optionSelected = val!;
                  } else if (widget.type == ChoiceListType.report) {
                    selectedOption = widget.choices?[index] ?? '';
                    widget.privacyProvider?.reportReasonSelected = val;

                    widget.privacyProvider?.reportReason =
                        widget.choices?[index];
                  }
                });
              },
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 1,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }
}
