import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RecentWordSearchCard extends StatelessWidget {
  final String searchWord;
  final VoidCallback onTap;

  const RecentWordSearchCard({
    super.key,
    required this.searchWord,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double elementSize = MediaQuery.of(context).size.width * 0.05;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: elementSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 12),
            Text(
              searchWord,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
