import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/companies_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/detailed_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/jobs_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/post_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/user_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailedSearchPage extends StatefulWidget {
  final String? searchText;

  const DetailedSearchPage({super.key, this.searchText = ""});

  @override
  State<DetailedSearchPage> createState() => _DetailedSearchPageState();
}

class _DetailedSearchPageState extends State<DetailedSearchPage> {
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = Provider.of<SearchProvider>(
        context,
        listen: false,
      );
      final text = widget.searchText ?? "";

      searchProvider.performSearchUser(isInitial: true, searchWord: text);
      searchProvider.performSearchJobs(isInitial: true, searchWord: text);
      searchProvider.performSearchCompany(isInitial: true, searchWord: text);
      searchProvider.performSearchPosts(isInitial: true, searchWord: text);
      searchProvider.getMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      key: const Key('key_detailed_search_scaffold'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        key: const Key('key_detailed_search_appbar'),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: GestureDetector(
          key: const Key('key_detailed_search_title_gesture'),
          onTap: () {
            searchProvider.filterType = FilterType.general;
            searchProvider.isSearching = false;
            searchProvider.clearSearchResults();
            Navigator.pop(context);
          },
          child: Container(
            key: const Key('key_detailed_search_title_container'),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.searchText ?? "Search",
                    key: const Key('key_detailed_search_text'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          key: const Key('key_detailed_search_back_button'),
          color: Theme.of(context).textTheme.titleMedium?.color,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            searchProvider.isSearching = false;
            searchProvider.clearSearchResults();
            Navigator.pop(context);
            searchProvider.filterType = FilterType.general;
          },
        ),
      ),
      body: Column(
        key: const Key('key_detailed_search_body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Filters Bar
          SingleChildScrollView(
            key: const Key('key_detailed_search_filters_scroll'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Row(
              key: const Key('key_detailed_search_filters_row'),
              children:
                  FilterType.values.map((filter) {
                    final label =
                        filter.name[0].toUpperCase() + filter.name.substring(1);
                    final isSelected = searchProvider.filterType == filter;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        key: Key('key_filter_chip_${filter.name}'),
                        label: Text(
                          label,
                          key: Key('key_filter_text_${filter.name}'),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            searchProvider.filterType = filter;
                          });
                        },
                        showCheckmark: false,
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        selectedColor: const Color.fromARGB(255, 43, 130, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          /// Conditional Search Results
          Expanded(
            child: Builder(
              builder: (context) {
                switch (searchProvider.filterType) {
                  case FilterType.general:
                    return const DetailedSearchBody(
                      key: Key('key_search_body_general'),
                    );
                  case FilterType.people:
                    return UserSearchBody(
                      key: const Key('key_search_body_people'),
                      query: widget.searchText ?? "",
                    );
                  case FilterType.posts:
                    return PostSearchBody(
                      key: const Key('key_search_body_posts'),
                      query: widget.searchText ?? "",
                    );
                  case FilterType.companies:
                    return CompanySearchBody(
                      key: const Key('key_search_body_companies'),
                      query: widget.searchText ?? "",
                    );
                  case FilterType.jobs:
                    return JobSearchBody(
                      key: const Key('key_search_body_jobs'),
                      query: widget.searchText ?? "",
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
