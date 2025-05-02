import 'package:linkedin_clone/features/admin_panel/domain/repositories/admin_repository.dart';

import '../entities/reported_user_entity.dart';

class FetchReportedUsers {
  final AdminRepository repository;

  FetchReportedUsers(this.repository);

  Future<List<ReportedUser>> call({String? status}) {
    return repository.fetchReportedUsers(status: status);
  }
}
