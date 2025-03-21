import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class EndorsementModel extends Equatable {
  final String userId;
  final String? profilePicUrl; // Nullable profile picture URL

  const EndorsementModel({
    required this.userId,
    this.profilePicUrl, // Now nullable
  });

  /// Convert JSON to `EndorsementModel`
  factory EndorsementModel.fromJson(Map<String, dynamic> json) {
    return EndorsementModel(
      userId: json['userId'] as String,
      profilePicUrl: json['profilePicUrl'] as String?, // Nullable
    );
  }

  /// Convert `EndorsementModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profilePicUrl': profilePicUrl, // Nullable
    };
  }

  /// Convert Model to Entity
  Endorsement toEntity() {
    return Endorsement(
      userId: userId,
      profilePicUrl: profilePicUrl, // Nullable
    );
  }

  /// Convert Entity to Model
  factory EndorsementModel.fromEntity(Endorsement entity) {
    return EndorsementModel(
      userId: entity.userId,
      profilePicUrl: entity.profilePicUrl, // Nullable
    );
  }

  @override
  List<Object?> get props => [userId, profilePicUrl]; // Nullable in props
}
