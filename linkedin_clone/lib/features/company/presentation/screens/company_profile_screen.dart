import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/media_remote_data_source.dart.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/domain/repositories/media_repository.dart';
import 'package:linkedin_clone/features/company/domain/usecases/upload_image_use_case.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/screens/companies_list_screen.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_edit_details_screen.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_list_followers.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_page_tabs.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_create_screen.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/utils/number_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../feed/presentation/provider/feed_provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  final String companyId;
  const CompanyProfileScreen({required this.companyId, super.key});
  void showPageOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Page options",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text("Share page"),
                    onTap: () {
                      print("Share Page Clicked");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.send),
                    title: Text("Send in a message"),
                    onTap: () {
                      print("Send in Message Clicked");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.flag),
                    title: Text("Report abuse"),
                    onTap: () {
                      print("Report Abuse Clicked");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Create a Tawasol Page"),
                    onTap: () {
                      print("Create a Tawasol Page Clicked");
                      Navigator.pop(context); // Close the sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create:
                                        (_) => CompanyCreateProvider(
                                          companyRepository:
                                              CompanyRepositoryImpl(
                                                remoteDataSource:
                                                    CompanyRemoteDataSource(),
                                              ),
                                          uploadImageUseCase: UploadImageUseCase(
                                            mediaRepository: MediaRepository(
                                              mediaRemoteDataSource:
                                                  MediaRemoteDataSource(),
                                            ),
                                          ),
                                        ),
                                  ),
                                ],
                                child: CreateCompanyScreen(),
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = CompanyProvider();
            provider.fetchCompanyDetails(companyId);
            provider.fetchFriendsFollowingCompany(companyId);
            return provider;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),

          title: Consumer<CompanyProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CompaniesListScreen()),
                  );
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextField(
                    key: const ValueKey('company_add_admin_field'),
                    controller: TextEditingController(
                      text: provider.company?.name,
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      hintText: 'Search companies...',
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await Provider.of<CompanyProvider>(
                  context,
                  listen: false,
                ).fetchCompanyDetails(companyId);
                await Provider.of<CompanyProvider>(
                  context,
                  listen: false,
                ).fetchFriendsFollowingCompany(companyId);
              },
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Required for pull-to-refresh
                child: Consumer<CompanyProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (provider.company != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    // Banner image
                                    (provider.hasValidBanner)
                                        ? Image.network(
                                          provider.company!.banner!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.08,
                                        )
                                        : Container(
                                          width: double.infinity,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.08,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.business,
                                            size: 30,
                                            color: Colors.grey[600],
                                          ),
                                        ),

                                    // Company logo
                                    (provider.hasValidLogo)
                                        ? Container(
                                          margin: EdgeInsets.only(
                                            top: 30,
                                            right: 270,
                                          ),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.12,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.12,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withAlpha(
                                                  (0.2 * 255).toInt(),
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                provider.company!.logo!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                        : Container(
                                          margin: EdgeInsets.only(
                                            top: 30,
                                            right: 270,
                                          ),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.12,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.12,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withAlpha(
                                                  (0.2 * 255).toInt(),
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.business,
                                              size: 30,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Company name and view mode toggle
                                      if (provider.isManager)
                                        Row(
                                          children: [
                                            Spacer(), // Pushes everything after it to the end
                                            Material(
                                              color:
                                                  Colors
                                                      .transparent, // Keeps background unchanged
                                              child: InkWell(
                                                onTap: () {
                                                  provider.toggleViewMode();
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ), // Increase touch area
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize
                                                            .min, // Only takes needed space
                                                    children: [
                                                      Text(
                                                        provider.isViewingAsUser
                                                            ? 'User View'
                                                            : 'Admin View',
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Icon(
                                                        provider.isViewingAsUser
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              provider.company!.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.headlineSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 4,
                                              children: [
                                                if (provider
                                                            .company
                                                            ?.industry !=
                                                        null &&
                                                    provider
                                                        .company!
                                                        .industry!
                                                        .isNotEmpty)
                                                  Text(
                                                    "${provider.company!.industry} •",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                                if (provider.company?.address !=
                                                        null &&
                                                    provider
                                                        .company!
                                                        .address!
                                                        .isNotEmpty)
                                                  Text(
                                                    "${provider.company!.address} •",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                                Text(
                                                  "${provider.company?.companySize ?? ''} •",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Navigate to the CompanyFollowersScreen
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => CompanyFollowersScreen(
                                                              companyId:
                                                                  provider
                                                                      .company
                                                                      ?.companyId ??
                                                                  "",
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "${formatNumber(provider.company?.followers ?? 0)} followers",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      provider.friendsFollowing.isNotEmpty
                                          ? Column(
                                            children: [
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                          provider
                                                              .friendsFollowing
                                                              .first
                                                              .profilePicture!,
                                                        ),
                                                    radius: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      provider
                                                                  .friendsFollowing
                                                                  .length ==
                                                              1
                                                          ? "${provider.friendsFollowing.first.firstName} follows this page"
                                                          : "${provider.friendsFollowing.first.firstName} & ${provider.friendsFollowing.length - 1} other connection(s) follow this page",
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                          : const SizedBox.shrink(),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Consumer<CompanyProvider>(
                                              builder: (
                                                context,
                                                provider,
                                                child,
                                              ) {
                                                return ElevatedButton(
                                                  key: const ValueKey(
                                                    'company_follow_button',
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        provider.isFollowing(
                                                              companyId,
                                                            )
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24,
                                                          ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    provider.toggleFollowStatus(
                                                      companyId,
                                                      companyId,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        provider.isFollowing(
                                                              companyId,
                                                            )
                                                            ? Icons.check
                                                            : Icons.add,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        provider.isFollowing(
                                                              companyId,
                                                            )
                                                            ? "Following"
                                                            : "Follow",
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            flex: 3,
                                            child: OutlinedButton(
                                              key: const ValueKey(
                                                'company_visit_website_button',
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                side: BorderSide(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                              ),
                                              onPressed: () async {
                                                final Uri url = Uri.parse(
                                                  context
                                                              .read<
                                                                CompanyProvider
                                                              >()
                                                              .company!
                                                              .website
                                                              ?.isEmpty ??
                                                          true
                                                      ? "https://www.google.com"
                                                      : context
                                                          .read<
                                                            CompanyProvider
                                                          >()
                                                          .company!
                                                          .website!,
                                                );

                                                await launchUrl(url);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Visit website"),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.open_in_new,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          // More Button (⋯)
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: IconButton(
                                                key: const ValueKey(
                                                  'company_more_button',
                                                ),
                                                iconSize: 20,
                                                padding:
                                                    EdgeInsets
                                                        .zero, // Remove extra padding
                                                constraints: BoxConstraints(),
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  showPageOptionsSheet(
                                                    context,
                                                  ); // Trigger bottom sheet
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context)
                                                .size
                                                .width, // Takes full screen width
                                        child: Divider(
                                          thickness: 1,
                                          height: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CompanyTabsWidget(companyId: companyId),
                                Divider(thickness: 3, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No company data found.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Consumer<CompanyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.company?.isManager == true &&
                    provider.isViewingAsUser == false) {
                  // Only show for admins
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Space from bottom
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditCompanyScreen(
                                    companyId: provider.company!.companyId!,
                                    company: UpdateCompanyEntity(
                                      name: provider.company!.name,
                                      description:
                                          provider.company!.description ?? '',
                                      companySize:
                                          provider.company!.companySize,
                                      location:
                                          provider.company!.location ?? '',
                                      email: provider.company!.email ?? '',
                                      companyType:
                                          provider.company!.companyType,
                                      industry: provider.company!.industry,
                                      overview:
                                          provider.company!.overview ?? '',
                                      founded: provider.company!.founded ?? 0,
                                      website: provider.company!.website ?? '',
                                      address: provider.company!.address ?? '',
                                      contactNumber:
                                          provider.company!.contactNumber ?? '',
                                      isVerified:
                                          provider.company!.isVerified ?? false,
                                      logo: provider.company!.logo ?? '',
                                      banner: provider.company!.banner ?? '',
                                    ),
                                  ),
                            ),
                          );

                          if (result == true) {
                            provider.fetchCompanyDetails(
                              provider.company!.companyId!,
                            ); // Refresh company details
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 24),
                              SizedBox(width: 6),
                              Text(
                                "Edit Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink(); // Return an empty widget if not admin
              },
            ),
          ],
        ),
      ),
    );
  }
}
