import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/general_search_result_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/recent_users_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/recent_words_body.dart';
import 'package:provider/provider.dart';

class GeneralSearchPage extends StatefulWidget {
  const GeneralSearchPage({super.key});

  @override
  State<GeneralSearchPage> createState() => _GeneralSearchPageState();
}

class _GeneralSearchPageState extends State<GeneralSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchProvider? searchProvider;
  String? searchText = "";

  @override
  void initState() {
    super.initState();
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider!.getRecentsearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: TextField(
          textInputAction: TextInputAction.search,
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: 'Search',
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            suffixIcon: IconButton(
              key: const ValueKey('close_search_button'),
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchText = value;
              searchProvider?.isSearching = value.isNotEmpty;
              if (value.isNotEmpty) {
                searchProvider!.preformSearch(
                  isInitial: true,
                  searchWord: value,
                );
              } else {
                searchProvider!.clearSearchResults();
              }
            });
          },
          onSubmitted: (value) {
            searchProvider!.addToRecentSearchesWords(value);
          },
        ),
        leading: IconButton(
          key: const ValueKey('back_button_search_page'),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<SearchProvider>(
              builder: (context, provider, _) {
                final recentWordsCount = provider.recentSearchesWords.length;
                final recentUsersCount = provider.recentSearchesUsers.length;

                if ((recentWordsCount > 0 || recentUsersCount > 0) &&
                    !provider.isSearching) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          key: const ValueKey('clear_all_button_search_page'),
                          onPressed: () {
                            provider.clearRecentSearches();
                          },
                          child: Text(
                            key: const ValueKey('clear_all_search_page_text'),
                            "Clear all",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            Consumer<SearchProvider>(
              builder: (context, provider, _) {
                final recentUsersCount = provider.recentSearchesUsers[0].length;

                if (recentUsersCount > 0 && !provider.isSearching) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RecentUsersBody(searchProvider: searchProvider),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            Consumer<SearchProvider>(
              builder: (context, provider, _) {
                final recentWordsCount = provider.recentSearchesWords.length;
                if (recentWordsCount > 0 && !provider.isSearching) {
                  return RecentWordsBody(searchProvider: searchProvider);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            if (searchProvider!.isSearching)
              Consumer<SearchProvider>(
                builder: (context, provider, _) {
                  final count = provider.searchResultsUsers.length;
                  if (count > 0) {
                    return GeneralSearchResultBody(
                      searchProvider: searchProvider,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),

            if (searchProvider!.isSearching)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    key: const ValueKey('show_all_results_button_search_page'),
                    onPressed: () {},
                    child: Text(
                      key: const ValueKey('show_all_results_search_page_text'),
                      "Show all Results",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
