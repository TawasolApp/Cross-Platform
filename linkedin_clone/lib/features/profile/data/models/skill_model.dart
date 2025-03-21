import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart'; // Import Skill entity
import 'endorsement_model.dart'; // Import Endorsement model

class SkillModel extends Equatable {
  final String skill;
  final List<EndorsementModel> endorsements;

  const SkillModel({
    required this.skill,
    required this.endorsements,
  });

  /// Convert `SkillModel` to `Skill` entity
  Skill toEntity() {
    return Skill(
      skill: skill,
      endorsements: endorsements.map((e) => e.toEntity()).toList(),
    );
  }

  /// Convert `Skill` entity to `SkillModel`
  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(
      skill: entity.skill,
      endorsements: entity.endorsements.map((e) => EndorsementModel.fromEntity(e)).toList(),
    );
  }

  /// Convert JSON to `SkillModel`
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skill: json['skill'] as String,
      endorsements: (json['endorsements'] as List<dynamic>?)
              ?.map((e) => EndorsementModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Convert `SkillModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'endorsements': endorsements.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [skill, endorsements];
}
