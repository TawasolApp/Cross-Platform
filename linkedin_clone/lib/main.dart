import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/user_profile.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart'; 
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:linkedin_clone/features/profile/data/repository/profile_repository_impl.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:linkedin_clone/core/network/connection_checker.dart';

void main() {
  // Initialize InternetConnectionCheckerPlus instance
  final internetConnection = InternetConnection();
  
  // Initialize data source and repository
  final ProfileRemoteDataSourceImpl dataSource = ProfileRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: 'https://your-api-url.com',
  );
  
  final profileRepository = ProfileRepositoryImpl(
    profileRemoteDataSource: dataSource,
    connectionChecker: ConnectionCheckerImpl(internetConnection),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            AddExperienceUseCase(profileRepository),
            UpdateExperienceUseCase(profileRepository),
            DeleteExperienceUseCase(profileRepository),
            AddEducationUseCase(profileRepository),
            UpdateEducationUseCase(profileRepository),
            DeleteEducationUseCase(profileRepository),
            AddCertificationUseCase(profileRepository),
            UpdateCertificationUseCase(profileRepository),
            DeleteCertificationUseCase(profileRepository),
            AddSkillUseCase(profileRepository),
            UpdateSkillUseCase(profileRepository),
            DeleteSkillUseCase(profileRepository),
            UpdateBioUseCase(profileRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TawasolApp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const UserProfile(),
    );
  }
}