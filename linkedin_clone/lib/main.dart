import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/data/datasources/connections_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/data/repository/connections_list_repository_impl.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/connections_page.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'core/themes/app_theme.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => ConnectionsProvider(
                GetConnectionsUseCase(
                  ConnectionsListRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                RemoveConnectionUseCase(
                  ConnectionsListRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
              ),
        ),
      ],
      child: MyApp(),
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
      home: ConnectionsPage(token: 'TokenPlaceHolder'),
    );
  }
}
