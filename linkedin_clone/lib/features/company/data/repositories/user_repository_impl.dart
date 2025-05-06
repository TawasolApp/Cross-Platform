import 'package:linkedin_clone/features/company/data/models/add_admin_request_model%20.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getCommonFollowers(String userId) async {
    return await remoteDataSource.getCommonFollowers(userId);
  }


  @override
  Future<void> addAdminUser(String newUserId,String companyId) async {
    final model = AddAdminRequestModel(newUserId: newUserId);
    await remoteDataSource.addAdminUser(model,companyId);
  }
}
