import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';

class CompanySearchCard extends StatelessWidget {
  final List<Company> companies;
  SearchProvider? _searchProvider;
  CompanySearchCard({super.key, required this.companies});

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context);
    final displayedCompanies =
        companies.length > 3 ? companies.sublist(0, 3) : companies;

    return Container(
      key: const Key('key_companysearch_container'),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        key: const Key('key_companysearch_main_column'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: const Key('key_companysearch_title_padding'),
            padding: const EdgeInsets.only(top: 18.0, left: 16.0),

            child: Text(
              "Companies",
              key: const Key('key_companysearch_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(key: Key('key_companysearch_spacer'), height: 10),
          Divider(
            key: const Key('key_companysearch_divider'),
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            key: const Key('key_companysearch_company_container'),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              key: const Key('key_companysearch_companies_column'),
              children:
                  displayedCompanies.asMap().entries.map((entry) {
                    int index = entry.key;
                    Company company = entry.value;
                    return Column(
                      key: Key('key_companysearch_company_item_$index'),
                      children: [
                        CompanyCard(
                          key: Key('key_companysearch_company_card_$index'),
                          company: company,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Center(
            key: const Key('key_companysearch_button_container'),
            child: TextButton(
              key: const Key('key_companysearch_see_all_button'),
              onPressed: () {
                _searchProvider?.filterType = FilterType.companies;
              },
              child: Text(
                "See all companies",
                key: const Key('key_companysearch_see_all_text'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
