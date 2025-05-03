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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 16.0),

            child: Text(
              "Companies",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Theme.of(context).dividerColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children:
                  displayedCompanies.map((company) {
                    return Column(children: [CompanyCard(company: company)]);
                  }).toList(),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                _searchProvider?.filterType = FilterType.companies;
              },
              child: Text(
                "See all companies",
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
