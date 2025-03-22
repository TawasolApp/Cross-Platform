import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart'; // Import the Endorsement entity

class Skill extends Equatable {
  final String skill;
  final List<Endorsement>? endorsements; // Made nullable

  const Skill({
    required this.skill,
    this.endorsements, // Nullable
  });

  @override
  List<Object?> get props => [skill, endorsements];
}
