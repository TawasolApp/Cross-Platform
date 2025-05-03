import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:provider/provider.dart';

class CompanySearchBody extends StatefulWidget {
  final String query;

  const CompanySearchBody({super.key, required this.query});

  @override
  State<CompanySearchBody> createState() => _CompanySearchBodyState();
}

class _CompanySearchBodyState extends State<CompanySearchBody> {
  late ScrollController _scrollController;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchProvider = Provider.of<SearchProvider>(context);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchProvider.hasMoreCompanies && !_searchProvider.isBusy) {
        _searchProvider.performSearchCompany(searchWord: widget.query);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Company> companies = _searchProvider.searchResultsCompanies;

    return ListView.builder(
      key: const Key('key_companysearch_listview'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: companies.length + 1,
      itemBuilder: (context, index) {
        if (index < companies.length) {
          final company = companies[index];
          return Column(
            key: Key('key_companysearch_column_$index'),
            children: [
              CompanyCard(
                key: Key('key_companysearch_card_$index'),
                company: company,
              ),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? Padding(
                key: const Key('key_companysearch_loading_container'),
                padding: const EdgeInsets.all(16),
                child: Center(
                  key: const Key('key_companysearch_loading_center'),
                  child: CircularProgressIndicator(
                    key: const Key('key_companysearch_loading_indicator'),
                  ),
                ),
              )
              : SizedBox(
                key: const Key('key_companysearch_bottom_spacer'),
                height: 30,
              );
        }
      },
    );
  }
}
