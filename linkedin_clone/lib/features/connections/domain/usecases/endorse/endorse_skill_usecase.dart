import 'package:cloud_firestore/cloud_firestore.dart';

import '../../repository/connections_repository.dart';

class EndorseSkillUseCase {
  final ConnectionsRepository repository;

  EndorseSkillUseCase(this.repository);

  Future<bool> call(String userId, String skillId) async {
    return await repository.endorseSkill(userId, skillId);
  }
}
