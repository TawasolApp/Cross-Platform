import 'package:flutter/material.dart';

class ManageMyNetworkCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? userId;
  final String? count;
  const ManageMyNetworkCard({
    super.key,
    this.title,
    this.icon,
    this.onTap,
    this.userId,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize =
        MediaQuery.of(context).size.width * 0.1 > 50
            ? 50
            : MediaQuery.of(context).size.width * 0.1;
    return Material(
      key: const Key('key_managenetworkcard_material'),
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.zero,
      child: Padding(
        key: const Key('key_managenetworkcard_padding'),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: InkWell(
          key: const Key('key_managenetworkcard_inkwell'),
          onTap: onTap,
          borderRadius: BorderRadius.zero,
          child: Row(
            key: const Key('key_managenetworkcard_row'),
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                key: const Key('key_managenetworkcard_icon'),
                icon,
                size: iconSize,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
              const SizedBox(
                key: Key('key_managenetworkcard_spacer1'),
                width: 8,
              ),
              Flexible(
                key: const Key('key_managenetworkcard_title_container'),
                fit: FlexFit.tight,
                child: Text(
                  key: const Key('key_managenetworkcard_title_text'),
                  title ?? 'Manage my network',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                key: Key('key_managenetworkcard_spacer2'),
                width: 8,
              ),
              Text(
                key: const Key('key_managenetworkcard_count_text'),
                count != null ? '$count' : '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
