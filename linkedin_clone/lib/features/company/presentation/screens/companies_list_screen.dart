import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:provider/provider.dart';

class CompaniesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyListProvider>(context, listen: false);

    // Fetch only once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.companies.isEmpty && !provider.isLoading) {
        provider.fetchCompanies();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Companies'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<CompanyListProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchCompanies(),
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }

                if (provider.companies.isEmpty) {
                  print('ehhh');
                  return const Center(child: Text('No companies found.'));
                }

                return ListView.separated(
                  itemCount: provider.companies.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
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
