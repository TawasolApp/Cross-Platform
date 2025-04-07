import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'endorsement_model.dart';

class SkillModel extends Equatable {
  final String skillName;
  // final List<EndorsementModel>? endorsements;
  final List<String?>? endorsements;
  final String? position;

  const SkillModel({required this.skillName, this.endorsements, this.position});

  /// Convert to Domain Entity
  Skill toEntity() {
    return Skill(
      skillName: skillName,
      // endorsements: endorsements?.map((e) => e.toEntity()).toList(),
      endorsements: endorsements,
      position: position,
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
      position: entity.position,
    );
  }

  /// Convert JSON to SkillModel
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skillName: json['skillName'] as String,
      // endorsements: (json['endorsements'] as List<dynamic>?)
      //     ?.map((e) => EndorsementModel.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      endorsements:
          (json['endorsements'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList(),
      position: json['position'] as String?,
    );
  }

  /// Convert SkillModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      // 'endorsements': endorsements?.map((e) => e.toJson()).toList(),
      'endorsements': endorsements,
      'position': position,
    };
  }

  /// Create a copy with modified fields
  SkillModel copyWith({
    String? skillName,
    List<String?>? endorsements,
    String? position,
  }) {
    return SkillModel(
      skillName: skillName ?? this.skillName,
      endorsements: endorsements ?? this.endorsements,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [skillName, endorsements, position];
}
