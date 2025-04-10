import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/related_companies_provider.dart';

class FullRelatedCompaniesScreen extends StatelessWidget {
  final String companyId;

  const FullRelatedCompaniesScreen({required this.companyId});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<RelatedCompaniesProvider>(
        context,
        listen: false,
      ).setCompanyId(companyId);
      Provider.of<RelatedCompaniesProvider>(
        context,
        listen: false,
      ).fetchRelatedCompanies(page: 1); // Start fetching related companies
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Related Companies")),
      body: Consumer<RelatedCompaniesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingState && provider.relatedCompanies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              provider.resetProvider();
              provider.fetchRelatedCompanies(page: 1);
            },
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount:
                  provider.relatedCompanies.length +
                  1, 
              separatorBuilder: (_, __) => Divider(thickness: 1),
              itemBuilder: (context, index) {
                if (index < provider.relatedCompanies.length) {
                  final company = provider.relatedCompanies[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          company.logo != null
                              ? NetworkImage(company.logo!)
                              : null,
                      child: company.logo == null ? Icon(Icons.business) : null,
                    ),
                    title: Text(company.name),
                    subtitle: Text(
                      "${company.industry ?? 'No industry info'}\n${company.followers} followers",
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CompanyProfileScreen(
                                companyId: company.companyId!,
                                title: company.name,
                              ),
                        ),
                      );
                    },
                  );
                } else if (provider.isAllLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: const Text('No more related companies available.'),
                    ),
                  );
                } else {
                  // Load more button
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child:
                          provider.isLoadingState
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: () {
                                  provider.loadMoreCompanies();
                                },
                                child: const Text('Load More'),
                              ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
