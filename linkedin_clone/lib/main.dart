import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/app_router.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/mock_auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/resend_email_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Data/Repository/auth_repository_impl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../features/feed/data/data_sources/feed_remote_data_source.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/usecases/get_posts_usecase.dart';
import '../features/feed/domain/usecases/create_post_usecase.dart';
import '../features/feed/presentation/pages/feed_page.dart';
import '../features/feed/presentation/pages/create_post_page.dart';
import '../features/feed/presentation/provider/feed_provider.dart';
import '../features/feed/domain/usecases/delete_post_usecase.dart';
import '../features/feed/domain/usecases/react_to_post_usecase.dart';
import 'package:linkedin_clone/core/themes/app_theme.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';

void main() {

  final useMock = true;
  // ignore: dead_code
  final AuthRemoteDataSource dataSource =useMock ? MockAuthRemoteDataSource() : AuthRemoteDataSourceImpl();

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
          create: (_) => AuthProvider(loginUseCase,forgotPassUseCase),
        ),
        ChangeNotifierProvider(create:(_) => RegisterProvider(registerUsecase: registerUseCase,resendEmailUsecase: resendEmailUsecase)),
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
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //theme: ThemeData(primarySwatch: Colors.blue),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      //routes: {'/create-post': (_) => const PostCreationPage()},

      routerConfig: AppRouter.router,
    );
  }
}

