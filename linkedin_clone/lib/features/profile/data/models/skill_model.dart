import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'endorsement_model.dart';

class SkillModel extends Equatable {
  final String skillName;
  // final List<EndorsementModel>? endorsements;
  final List<String?>? endorsements;

  const SkillModel({
    required this.skillName,
    this.endorsements,
  });

  /// Convert to Domain Entity
  Skill toEntity() {
    return Skill(
      skillName: skillName,
      // endorsements: endorsements?.map((e) => e.toEntity()).toList(),
      endorsements: endorsements
    );
  }

  /// Create from Domain Entity
  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(
      skillName: entity.skillName,
      // endorsements: entity.endorsements
      //     ?.map((e) => EndorsementModel.fromEntity(e))
      //     .toList(),
      endorsements: entity.endorsements,
    );
  }

  /// Convert JSON to SkillModel
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skillName: json['skillName'] as String,
      // endorsements: (json['endorsements'] as List<dynamic>?)
      //     ?.map((e) => EndorsementModel.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      endorsements: (json['endorsements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Convert SkillModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      // 'endorsements': endorsements?.map((e) => e.toJson()).toList(),
      'endorsements': endorsements,
    };
  }

  /// Create a copy with modified fields
  SkillModel copyWith({
    String? skill,
    // List<EndorsementModel>? endorsements,
    List<String?>? endorsements,
  }) {
    return SkillModel(
      skillName: skill ?? this.skillName,
      endorsements: endorsements ?? this.endorsements,
    );
  }

  @override
  List<Object?> get props => [skillName, endorsements];
}