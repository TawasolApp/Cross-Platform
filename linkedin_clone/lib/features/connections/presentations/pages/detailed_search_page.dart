import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/companies_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/detailed_search_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/jobs_search_body.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Filters Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Row(
              children:
                  FilterType.values.map((filter) {
                    final label =
                        filter.name[0].toUpperCase() + filter.name.substring(1);
                    final isSelected = searchProvider.filterType == filter;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(label),
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
                    return const DetailedSearchBody();
                  case FilterType.people:
                    return UserSearchBody(query: widget.searchText ?? "");
                  case FilterType.posts:
                    return const DetailedSearchBody();
                  case FilterType.companies:
                    return CompanySearchBody(query: widget.searchText ?? "");
                  case FilterType.jobs:
                    return JobSearchBody(query: widget.searchText ?? "");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
