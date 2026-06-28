import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/recent_word_search_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';

// ignore: must_be_immutable
class RecentWordsBody extends StatelessWidget {
  SearchProvider? searchProvider;
  RecentWordsBody({super.key, required this.searchProvider});

  @override
  Widget build(BuildContext context) {
    List<String> recentWords = searchProvider!.recentSearchesWords;
    return Column(
      key: const Key('recent_words_column'),
      children: List.generate(recentWords.length, (index) {
        return RecentWordSearchCard(
          key: Key('recent_word_card_$index'),
          searchWord: recentWords[index],
          onTap: () {
            goToDetailedSearchPage(context, searchText: recentWords[index]);
          },
        );
      }),
    );
  }
}
