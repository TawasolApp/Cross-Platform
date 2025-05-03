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
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.zero,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
              const SizedBox(width: 8),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  title ?? 'Manage my network',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: 8),
              Text(
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
