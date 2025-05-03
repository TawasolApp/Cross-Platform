import 'package:flutter/material.dart';

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
      key: Key('recent_word_search_inkwell_$searchWord'),
      onTap: onTap,
      child: Container(
        key: Key('recent_word_search_container_$searchWord'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          key: Key('recent_word_search_row_$searchWord'),
          children: [
            Icon(
              key: Key('recent_word_search_history_icon_$searchWord'),
              Icons.history,
              size: elementSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(key: Key('recent_word_search_spacer'), width: 12),
            Text(
              key: Key('recent_word_search_text_$searchWord'),
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
