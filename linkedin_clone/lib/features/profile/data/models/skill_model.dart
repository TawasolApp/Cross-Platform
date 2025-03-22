import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'endorsement_model.dart';

class SkillModel extends Skill with EquatableMixin {
  SkillModel({
    required super.skill,
    super.endorsements,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skill: json['skill'] as String,
      endorsements: (json['endorsements'] as List<dynamic>?)
          ?.map((e) => EndorsementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'endorsements': endorsements?.map((e) => (e as EndorsementModel).toJson()).toList(),
    };
  }

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
