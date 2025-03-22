import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/experience_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skills_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/about_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/certifications_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/plan_details_section.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/plan_statistics_section.dart';

class UserProfile extends StatelessWidget {
  final String? userBio;

  const UserProfile({super.key, this.userBio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE), // LinkedIn-like Background
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Profile Header**
              Container(
                color: Colors.white, 
                child: ProfileHeader(),
              ),
              const SizedBox(height: 10),

              // **Plan Details**
              Container(
                color: Colors.white,
                child: PlanDetails(
                  planName: "Premium Career",
                  expirationDate: "April 30, 2025",
                  autoRenewal: true,
                ),
              ),
              const SizedBox(height: 10),

              // **Plan Statistics**
              Container(
                color: Colors.white,
                child: PlanStatistics(
                  messagesSent: 50,
                  applicationsSubmitted: 15,
                ),
              ),
              const SizedBox(height: 10),

              // **About Section**
              if (userBio != null && userBio!.trim().isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  child: AboutSection(bio: userBio!),
                ),
                const SizedBox(height: 10),
              ],

              // **Experience Section**
              Container(
                color: Colors.white, 
                child: ExperienceSection(),
              ),
              const SizedBox(height: 10),

              // **Education Section**
              Container(
                color: Colors.white, 
                child: EducationSection(),
              ),
              const SizedBox(height: 10),

              // **Certifications Section**
              Container(
                color: Colors.white, 
                child: CertificationsSection(),
              ),
              const SizedBox(height: 10),

              // **Skills Section**
              Container(
                color: Colors.white, 
                child: SkillsSection(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
