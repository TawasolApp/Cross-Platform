import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class Skill extends Equatable {
  final String skillName;
  // final List<Endorsement>? endorsements;
  final List<String?>? endorsements;
  final String? position;

  const Skill({
    required this.skillName,
    this.endorsements,
    this.position,
  });

  Skill copyWith({
    String? skillName,
    List<String?>? endorsements,
    String? position,
  }) {
    return Skill(
      skillName: skillName ?? this.skillName,
      endorsements: endorsements ?? this.endorsements,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [skillName, endorsements, position];
}
