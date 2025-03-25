import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class EndorsementModel extends Equatable {
  final String userId;
  final String? profilePicUrl;

  const EndorsementModel({
    required this.userId,
    this.profilePicUrl,
  });

  /// Convert to Domain Entity
  Endorsement toEntity() {
    return Endorsement(
      userId: userId,
      profilePicUrl: profilePicUrl,
    );
  }

  /// Create from Domain Entity
  factory EndorsementModel.fromEntity(Endorsement entity) {
    return EndorsementModel(
      userId: entity.userId,
      profilePicUrl: entity.profilePicUrl,
    );
  }

  /// Convert JSON to EndorsementModel
  factory EndorsementModel.fromJson(Map<String, dynamic> json) {
    return EndorsementModel(
      userId: json['userId'] as String,
      profilePicUrl: json['profilePicUrl'] as String?,
    );
  }

  /// Convert EndorsementModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profilePicUrl': profilePicUrl,
    };
  }

  /// Create a copy with modified fields
  EndorsementModel copyWith({
    String? userId,
    String? profilePicUrl,
  }) {
    return EndorsementModel(
      userId: userId ?? this.userId,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    );
  }

  @override
  List<Object?> get props => [userId, profilePicUrl];
}