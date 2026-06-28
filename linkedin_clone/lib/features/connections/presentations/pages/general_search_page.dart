import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/general_search_result_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/recent_users_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/recent_words_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
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
      key: const Key('key_general_search_scaffold'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        key: const Key('key_general_search_appbar'),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Center(
          key: const Key('key_general_search_title_center'),
          child: TextField(
            key: const Key('key_general_search_textfield'),
            textInputAction: TextInputAction.search,
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
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
                key: const Key('key_general_search_clear_button'),
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchText = "";
                    searchProvider?.isSearching = false;
                    searchProvider?.clearSearchResults();
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
                searchProvider?.isSearching = value.isNotEmpty;
                if (value.isNotEmpty) {
                  searchProvider!.performSearchUser(
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
              goToDetailedSearchPage(
                context,
                searchText: value,
              ); // Navigate to detailed search page
            },
          ),
        ),
        leading: IconButton(
          key: const Key('key_general_search_back_button'),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            _searchController.clear();
            searchText = "";
            searchProvider?.isSearching = false;
            searchProvider?.clearSearchResults();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        key: const Key('key_general_search_scroll'),
        child: Container(
          key: const Key('key_general_search_container'),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          child: Column(
            key: const Key('key_general_search_column'),
            children: [
              Consumer<SearchProvider>(
                builder: (context, provider, _) {
                  if ((provider.recentSearchesWords.isNotEmpty ||
                          provider.recentSearchesUsers[0].isNotEmpty) &&
                      !provider.isSearching) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: Row(
                        key: const Key('key_general_search_clear_row'),
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            key: const Key(
                              'key_general_search_clear_all_button',
                            ),
                            onPressed: () {
                              provider.clearRecentSearches();
                            },
                            child: Text(
                              key: const Key(
                                'key_general_search_clear_all_text',
                              ),
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
                  final recentUsersCount =
                      provider.recentSearchesUsers[0].length;

                  if (recentUsersCount > 0 && !provider.isSearching) {
                    return Padding(
                      key: const Key(
                        'key_general_search_recent_users_container',
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RecentUsersBody(
                        key: const Key('key_general_search_recent_users_body'),
                        searchProvider: searchProvider,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Consumer<SearchProvider>(
                builder: (context, provider, _) {
                  final recentWordsCount = provider.recentSearchesWords.length;
                  if (recentWordsCount > 0 && !provider.isSearching) {
                    return RecentWordsBody(
                      key: const Key('key_general_search_recent_words_body'),
                      searchProvider: searchProvider,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              if (searchProvider!.isSearching)
                Consumer<SearchProvider>(
                  builder: (context, provider, _) {
                    final count = provider.searchResultsUsers.length;
                    if (count > 0) {
                      return GeneralSearchResultBody(
                        key: const Key('key_general_search_results_body'),
                        searchProvider: searchProvider,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

              if (searchProvider!.isSearching)
                Align(
                  key: const Key('key_general_search_show_all_align'),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      key: const Key('key_general_search_show_all_button'),
                      onPressed: () {
                        searchProvider!.addToRecentSearchesWords(
                          _searchController.text,
                        );
                        goToDetailedSearchPage(
                          context,
                          searchText: _searchController.text,
                        );
                      },
                      child: Text(
                        key: const Key('key_general_search_show_all_text'),
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
      ),
    );
  }
}
