import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/Navigation/app_router.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/mock_auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Repository/auth_repository_impl.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/resend_email_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/connections/data/datasources/connections_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/data/repository/connections_repository_impl.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/accept_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/ignore_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../features/feed/data/data_sources/feed_remote_data_source.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/usecases/create_post_usecase.dart';
import '../features/feed/domain/usecases/delete_post_usecase.dart';
import '../features/feed/domain/usecases/get_posts_usecase.dart';
import '../features/feed/presentation/provider/feed_provider.dart';
import 'core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/user_profile.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:linkedin_clone/features/profile/data/data_sources/profile_remote_data_source.dart';
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
import 'package:linkedin_clone/features/profile/data/data_sources/mock_profile_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import "../../../features/connections/presentations/pages/connections_page.dart";

void main() {
  // Initialize InternetConnectionCheckerPlus instance
  final internetConnection = InternetConnection();

  // Initialize data source and repository
  // final ProfileRemoteDataSourceImpl dataSource = ProfileRemoteDataSourceImpl(
  //   client: http.Client(),
  //   baseUrl: 'https://your-api-url.com',
  // );

  final MockProfileRemoteDataSource dataSourceProfile =
      MockProfileRemoteDataSource();

  final profileRepository = ProfileRepositoryImpl(
    profileRemoteDataSource: dataSourceProfile,
    connectionChecker: ConnectionCheckerImpl(internetConnection),
  );
  final useMock = true;
  // ignore: dead_code
  final AuthRemoteDataSource dataSource =
      useMock ? MockAuthRemoteDataSource() : AuthRemoteDataSourceImpl();

  final AuthRepository authRepository = AuthRepositoryImpl(dataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final forgotPassUseCase = ForgotPassUseCase(authRepository);
  final resendEmailUsecase = ResendEmailUsecase(authRepository);
  final dio = Dio();
  final remoteDataSource = FeedRemoteDataSourceImpl(dio);
  final repository = FeedRepositoryImpl(remoteDataSource: remoteDataSource);

  final getPostsUseCase = GetPostsUseCase(repository);
  final createPostUseCase = CreatePostUseCase(repository);
  final deletePostUseCase = DeletePostUseCase(repository);
  final savePostUseCase = SavePostUseCase(repository);
  WebViewPlatform.instance = AndroidWebViewPlatform();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase, forgotPassUseCase),
        ),
        ChangeNotifierProvider(
          create:
              (_) => RegisterProvider(
                registerUsecase: registerUseCase,
                resendEmailUsecase: resendEmailUsecase,
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FeedProvider(
                getPostsUseCase: getPostsUseCase,
                createPostUseCase: createPostUseCase,
                deletePostUseCase: deletePostUseCase,
                savePostUseCase: savePostUseCase,
                //reactToPostUseCase: reactToPostUseCase,
              )..fetchPosts(),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ConnectionsProvider(
                GetConnectionsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                RemoveConnectionUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetReceivedConnectionRequestsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetSentConnectionRequestsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                AcceptConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                IgnoreConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                SendConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ProfileProvider(
                GetProfileUseCase(profileRepository),
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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Flutter Demo',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       //theme: ThemeData(primarySwatch: Colors.blue),
//       themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,

//       //routes: {'/create-post': (_) => const PostCreationPage()},
//       routerConfig: AppRouter.router,
//     );
//   }
//}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: InvitationsPage(
        token: "wewa",
      ), // Change this to your desired initial page
    );
  }
}
