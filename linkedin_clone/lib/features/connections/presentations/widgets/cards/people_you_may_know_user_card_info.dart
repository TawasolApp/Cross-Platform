import 'package:flutter/material.dart';

class PeopleYouMayKnowUserCardInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? headLine;

  const PeopleYouMayKnowUserCardInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.headLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('key_pymk_info_column'),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$firstName $lastName',
          key: const Key('key_pymk_info_name_text'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.2),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),

        SizedBox(
          key: const Key('key_pymk_info_headline_container'),
          height: 1.2 * 2 * Theme.of(context).textTheme.bodyMedium!.fontSize!,
          child: Text(
            headLine != "notavailable" ? headLine! : "",
            key: const Key('key_pymk_info_headline_text'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
