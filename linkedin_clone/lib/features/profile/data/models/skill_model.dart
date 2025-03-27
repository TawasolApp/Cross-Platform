import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'endorsement_model.dart';

class SkillModel extends Equatable {
  final String skill;
  final List<EndorsementModel>? endorsements;

  const SkillModel({
    required this.skill,
    this.endorsements,
  });

  /// Convert to Domain Entity
  Skill toEntity() {
    return Skill(
      skill: skill,
      endorsements: endorsements?.map((e) => e.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(
      skill: entity.skill,
      endorsements: entity.endorsements
          ?.map((e) => EndorsementModel.fromEntity(e))
          .toList(),
    );
  }

  /// Convert JSON to SkillModel
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skill: json['skill'] as String,
      endorsements: (json['endorsements'] as List<dynamic>?)
          ?.map((e) => EndorsementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert SkillModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'endorsements': endorsements?.map((e) => e.toJson()).toList(),
    };
  }

  /// Create a copy with modified fields
  SkillModel copyWith({
    String? skill,
    List<EndorsementModel>? endorsements,
  }) {
    return SkillModel(
      skill: skill ?? this.skill,
      endorsements: endorsements ?? this.endorsements,
    );
  }

  @override
  List<Object?> get props => [skill, endorsements];
}