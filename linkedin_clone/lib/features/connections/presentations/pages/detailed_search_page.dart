import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/detailed_search_body.dart';
import 'package:linkedin_clone/features/premium/presentations/pages/choose_premium_plan_page.dart';
import 'package:provider/provider.dart';

enum FilterType { general, people, posts, companies, jobs }

class DetailedSearchPage extends StatefulWidget {
  final String? searchText;
  final FilterType? filterType;

  const DetailedSearchPage({
    super.key,
    this.searchText = "",
    this.filterType = FilterType.general,
  });

  @override
  State<DetailedSearchPage> createState() => _DetailedSearchPageState();
}

class _DetailedSearchPageState extends State<DetailedSearchPage> {
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    // Safe usage of Provider in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchProvider = Provider.of<SearchProvider>(context, listen: false);

      final text = widget.searchText ?? "";

      _searchProvider.performSearchUser(isInitial: true, searchWord: text);
      _searchProvider.performSearchJobs(isInitial: true, searchWord: text);
      _searchProvider.performSearchCompany(isInitial: true, searchWord: text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Back to general search page
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
            _searchProvider.isSearching = false;
            _searchProvider.clearSearchResults();
            Navigator.pop(context);
          },
        ),
      ),
      body: DetailedSearchBody(),
    );
  }
}
