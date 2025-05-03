import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/utils/time_formatter.dart';
import '../misc/connections_enums.dart';

class UserCardInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? headLine;
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
      key: const Key('key_usercardinfo_main_column'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$firstName $lastName',
          key: const Key('key_usercardinfo_name_text'),
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          headLine!,
          key: const Key('key_usercardinfo_headline_text'),
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (cardType == PageType.pending || cardType == PageType.connections)
          const SizedBox(key: Key('key_usercardinfo_spacer'), height: 5),
        if (cardType == PageType.pending)
          Text(
            formatTime(time),
            key: const Key('key_usercardinfo_pending_time_text'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (cardType == PageType.sent)
          Text(
            "Sent ${formatTime(time)}",
            key: const Key('key_usercardinfo_sent_time_text'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (cardType == PageType.connections)
          Text(
            formatTime(time),
            key: const Key('key_usercardinfo_connections_time_text'),
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
