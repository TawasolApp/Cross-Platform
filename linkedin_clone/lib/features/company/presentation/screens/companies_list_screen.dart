import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:provider/provider.dart';

class CompaniesListScreen extends StatefulWidget {
  const CompaniesListScreen({super.key});

  @override
  _CompaniesListScreenState createState() => _CompaniesListScreenState();
}

class _CompaniesListScreenState extends State<CompaniesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyListProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Companies'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Reset provider and fetch companies based on new query
                provider.resetProvider();
                provider.fetchCompanies(value.trim(), page: 1, limit: 5);
              },
              decoration: InputDecoration(
                hintText: 'Search companies...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CompanyListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              // Reset provider and fetch companies again
              provider.resetProvider();
              provider.fetchCompanies(
                _searchController.text.trim(),
                page: 1,
                limit: 5,
              );
            },
            child: Builder(
              builder: (_) {
                // Show a loading spinner if fetching companies
                if (provider.isLoading && provider.companies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show error message if there's an error
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }

                // Show message when no companies are found
                if (provider.companies.isEmpty) {
                  return const Center(child: Text('No companies found.'));
                }

                return ListView.separated(
                  itemCount:
                      provider.companies.length + 1, // +1 for load more button
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    // Inside itemBuilder
                    if (index < provider.companies.length) {
                      final company = provider.companies[index];
                      return ListTile(
                        leading:
                            company.logo == null
                                ? const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.business,
                                    color: Colors.black,
                                  ),
                                )
                                : CircleAvatar(
                                  backgroundImage: NetworkImage(company.logo!),
                                  backgroundColor: Colors.transparent,
                                ),
                        title: Text(company.name),
                        subtitle: Text(company.industry),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CompanyProfileScreen(
                                    companyId: company.companyId!,
                                    title: company.name,
                                  ),
                            ),
                          );
                        },
                      );
                    } else if (provider.isAllLoaded) {
                      // If all companies are loaded, show "No more companies"
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: const Text('No more companies available.'),
                        ),
                      );
                    } else {
                      // Load more button
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Load next set of companies (next page)
                              provider.loadMoreCompanies(
                                _searchController.text.trim(),
                              );
                            },
                            child: const Text('Load More'),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
