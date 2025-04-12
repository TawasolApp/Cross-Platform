import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/linkedin_iconic_button.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart'; // Ensure this is the correct path
import 'page_type_enum.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/features/connections/data/datasources/connections_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/data/repository/connections_repository_impl.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/accept_ignore_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/withdraw_connection_request_usecase.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final connectionsProvider = ConnectionsProvider(
      GetConnectionsUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      RemoveConnectionUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      GetReceivedConnectionRequestsUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      GetSentConnectionRequestsUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      AcceptIgnoreConnectionRequestUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      SendConnectionRequestUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
      WithdrawConnectionRequestUseCase(
        ConnectionsRepositoryImpl(
          remoteDataSource: ConnectionsRemoteDataSource(client: http.Client()),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          child: LinkedInIconicButton(
            onPressed: () async {},
            label: 'Test Manage My network',
          ),
        ),
      ),
    );
  }
}
