import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_list_related_companies.dart';

class CompanyAboutWidget extends StatelessWidget {
  final String companyId;
  CompanyAboutWidget(this.companyId, {super.key});

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
          Text("Description", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text(
            context.read<CompanyProvider>().company?.description?.isEmpty ??
                    true
                ? 'No description available'
                : context.read<CompanyProvider>().company?.description ??
                    'No description available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          Text("Details", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text('Website', style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(
                context.read<CompanyProvider>().company!.website?.isEmpty ??
                        true
                    ? "https://www.google.com"
                    : context.read<CompanyProvider>().company!.website!,
              );
              await launchUrl(url);
            },
            child: Text(
              context.read<CompanyProvider>().company!.website?.isEmpty ?? true
                  ? 'No website available'
                  : context.read<CompanyProvider>().company!.website!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                decoration:
                    TextDecoration.underline, 
              ),
            ),
          ),
          SizedBox(height: 4),
          Text('Industry', style: Theme.of(context).textTheme.titleMedium),
          Text(
            context.read<CompanyProvider>().company!.industry.isEmpty
                ? 'No industry available'
                : context.read<CompanyProvider>().company!.industry,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4),
          Text('Headquarters', style: Theme.of(context).textTheme.titleMedium),
          Text(
            context.read<CompanyProvider>().company!.address?.isEmpty ?? true
                ? 'No address available'
                : context.read<CompanyProvider>().company!.address!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4),
          Text('Company Size', style: Theme.of(context).textTheme.titleMedium),
          Text(
            context.read<CompanyProvider>().company!.companySize.isEmpty
                ? 'No company size available'
                : context.read<CompanyProvider>().company!.companySize,
            style: Theme.of(context).textTheme.bodyMedium,
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
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children:
                          relatedCompanies.take(4).map((relatedCompany) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => CompanyProfileScreen(
                                                companyId:
                                                    relatedCompany.companyId!,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              relatedCompany.logo != null
                                                  ? NetworkImage(
                                                    relatedCompany.logo!,
                                                  )
                                                  : null,
                                          child:
                                              relatedCompany.logo == null
                                                  ? const Icon(Icons.business)
                                                  : null,
                                          radius: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                relatedCompany.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                relatedCompany.industry ??
                                                    'No industry info',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                              ),
                                              const SizedBox(height: 2),
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
                                            companyProvider.isFollowing(
                                                  relatedCompany.companyId!,
                                                )
                                                ? Icons.check_circle
                                                : Icons.add_circle_outline,
                                            color:
                                                companyProvider.isFollowing(
                                                      relatedCompany.companyId!,
                                                    )
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : Colors.black54,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            await companyProvider
                                                .toggleFollowStatus(
                                                  relatedCompany.companyId!,
                                                  companyProvider
                                                      .company!
                                                      .companyId!,
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.black38,
                                ),
                              ],
                            );
                          }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FullRelatedCompaniesScreen(
                                companyId: companyId,
                              ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Show all companies",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.arrow_forward, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
