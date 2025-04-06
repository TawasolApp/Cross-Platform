import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class Skill extends Equatable {
  final String skillName;
  // final List<Endorsement>? endorsements;
  final List<String?>? endorsements;

  const Skill({
    required this.skillName,
    this.endorsements,
  });

  Skill copyWith({String? skillName, /*List<Endorsement>?*/ List<String?>? endorsements}) {
    return Skill(
      skillName: skillName ?? this.skillName,
      endorsements: endorsements ?? this.endorsements,
    );
  }

  @override
  List<Object?> get props => [skillName, endorsements];
}
