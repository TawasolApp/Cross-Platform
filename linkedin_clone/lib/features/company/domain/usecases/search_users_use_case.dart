import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';

class SearchUsersUseCase {
  final UserRemoteDataSource userRemoteDataSource;

  SearchUsersUseCase({required this.userRemoteDataSource});

  Future<List<User>> execute(String query) async {
    return await userRemoteDataSource.searchUsers(query);
  }
}
