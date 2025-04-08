import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/utils/time_formatter.dart';
import 'page_type_enum.dart';

class UserCardInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String headLine;
  final String time;
  final PageType cardType;

  const UserCardInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.time,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            '$firstName $lastName',
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            headLine,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (cardType == PageType.pending || cardType == PageType.connections)
          const SizedBox(height: 5),
        if (cardType == PageType.pending)
          Flexible(
            child: Text(
              formatTime(time),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (cardType == PageType.sent)
          Expanded(
            child: Text(
              "Sent $formatTime(time)",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (cardType == PageType.connections)
          Flexible(
            child: Text(
              formatTime(time),
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
