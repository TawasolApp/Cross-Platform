import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart'; // Ensure this is the correct path
import 'page_type_enum.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/features/connections/data/datasources/connections_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/data/repository/connections_repository_impl.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/accept_ignore_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/withdraw_connection_request_usecase.dart';

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
          child: UserCard(
            userId: "dddd",
            firstName: "John",
            lastName: "Doe",
            headLine: "Software Engineer",
            profilePicture:
                "https://media.licdn.com/dms/image/v2/D4D35AQH1S3JD3cDFFA/profile-framedphoto-shrink_200_200/profile-framedphoto-shrink_200_200/0/1729799729935?e=1744682400&v=beta&t=RPxvWcRkLixNa4PCzSP47Dj-s59Yjamc3XZRHtlj8hU",
            cardType: PageType.connections,
            connectionsProvider: connectionsProvider,
          ),
        ),
      ),
    );
  }
}
