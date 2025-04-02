import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyAboutWidget extends StatelessWidget {
  final String userID;
  CompanyAboutWidget(this.userID);
  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final company = companyProvider.company;
    final relatedCompanies = companyProvider.relatedCompanies;
    if (company == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Overview", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text(
            context.read<CompanyProvider>().company!.overview ?? 'No overview available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          Text("Details", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),

          Text('Website', style: Theme.of(context).textTheme.bodyLarge),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(
                context.read<CompanyProvider>().company!.website ??
                    "https://www.google.com",
              );

              await launchUrl(url);
            },
            child: Text(
              context.read<CompanyProvider>().company!.website ??
                  'No website available',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(height: 4),
          Text('Industry', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            context.read<CompanyProvider>().company!.industry,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text('Headquarters', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            context.read<CompanyProvider>().company!.address ?? 'No address available',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text('Company Size', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            '${context.read<CompanyProvider>().company!.companySize} employees',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 8),

          // Related Companies Section
          if (relatedCompanies.isNotEmpty) ...[
            Text(
              "Pages People Also Viewed",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),

            Column(
              children:
                  relatedCompanies.take(4).map((relatedCompany) {
                    final isFollowing = companyProvider.isFollowing;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Company Logo
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  relatedCompany.logo ?? '',
                                ),
                                radius: 24,
                                onBackgroundImageError:
                                    (_, __) => Icon(Icons.business, size: 24),
                              ),
                              SizedBox(width: 12),

                              // Company Info (Name, Industry, Followers)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      relatedCompany.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      relatedCompany.industry ??
                                          'No industry info',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '${relatedCompany.followers} followers',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFollowing(relatedCompany.companyId)
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color:
                                      isFollowing(relatedCompany.companyId)
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Colors.black54,
                                  size: 32,
                                ),
                                onPressed: () {
                                  companyProvider.toggleFollowStatus(
                                    userID,
                                    relatedCompany.companyId,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.black38),
                      ],
                    );
                  }).toList(),
            ),

            SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  //TODO: Implement navigation to the full list of related companies
                  // Navigate to the full list of related companies
                  // Navigator.of(context).pushNamed(RelatedCompaniesScreen.routeName);
                },
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers content
                  children: [
                    Text(
                      "Show all companies",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, color: Colors.grey[700]),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
