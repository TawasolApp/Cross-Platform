import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/general_search_card.dart';

// ignore: must_be_immutable
class GeneralSearchResultBody extends StatelessWidget {
  SearchProvider? searchProvider;
  GeneralSearchResultBody({super.key, required this.searchProvider});

  @override
  Widget build(BuildContext context) {
    List<ConnectionsUserEntity> results = searchProvider!.searchResultsUsers;
    return SizedBox(
      key: const Key('key_generalsearchresult_container'),
      width: MediaQuery.of(context).size.width,
      child: Column(
        key: const Key('key_generalsearchresult_column'),
        children: List.generate(results.length, (index) {
          return Padding(
            key: Key('key_generalsearchresult_padding_$index'),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              key: Key('key_generalsearchresult_box_$index'),
              height: MediaQuery.of(context).size.height * 0.07,
              child: GeneralSearchCard(
                key: Key('key_generalsearchresult_card_$index'),
                provider: searchProvider!,
                user: results[index],
              ),
            ),
          );
        }),
      ),
    );
  }
}
