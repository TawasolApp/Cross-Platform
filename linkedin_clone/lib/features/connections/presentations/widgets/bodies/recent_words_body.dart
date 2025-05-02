import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/recent_word_search_card.dart';

// ignore: must_be_immutable
class RecentWordsBody extends StatelessWidget {
  SearchProvider? searchProvider;
  RecentWordsBody({super.key, required this.searchProvider});

  @override
  Widget build(BuildContext context) {
    List<String> recentWords = searchProvider!.recentSearchesWords;
    return Column(
      children: List.generate(recentWords.length, (index) {
        return RecentWordSearchCard(
          searchWord: recentWords[index],
          onTap: () {
            // goToProfile(context, userId: user['userId']);
          },
        );
      }),
    );
  }
}
