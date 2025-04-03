import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_about_tab_widget.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_home_tab_widget.dart';
import 'package:linkedin_clone/features/company/presentation/widgets/company_jobs_tab_widget.dart';

class CompanyTabsWidget extends StatelessWidget {
  final String userId; // Accepting userId as a parameter
  final String companyId;
  CompanyTabsWidget({required this.userId, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Theme.of(context).colorScheme.primary,
            labelPadding: EdgeInsets.symmetric(horizontal: 0), // Adjust spacing
            indicatorColor: Colors.blue, // Customize as needed
            tabs: [
              Tab(text: "Home"),
              Tab(text: "About"),
              Tab(text: "Posts"),
              Tab(text: "Jobs"),
            ],
          ),
          SizedBox(
            height: 500, // TODO:Change this to be make the whole screen scroablle
            child: TabBarView(
              children: [
                CompanyHomeTab(userId: userId),
                CompanyAboutWidget(userId),
                Center(child: Text("Posts Content")),
                CompanyJobsWidget(userId: userId,companyId: companyId,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
