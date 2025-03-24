import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/app_router.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/mock_auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Data/Repository/auth_repository_impl.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source.dart';

void main() {
  final mockRemote  = MockAuthRemoteDataSource(); // your API call layer
  final authRepository = AuthRepositoryImpl(mockRemote);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUsecase(authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase),
        ),
        ChangeNotifierProvider(create:(_) => RegisterProvider(registerUsecase: registerUseCase)),
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
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      routerConfig: AppRouter.router,
    );
  }
}

