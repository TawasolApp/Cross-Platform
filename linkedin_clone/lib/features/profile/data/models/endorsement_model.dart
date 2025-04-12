import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class EndorsementModel extends Equatable {
  final String userId;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;

  const EndorsementModel({
    required this.userId,
    this.profilePicture,
    this.firstName,
    this.lastName,
  });

  /// Convert to Domain Entity
  Endorsement toEntity() {
    return Endorsement(
      userId: userId,
      profilePicture: profilePicture,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Create from Domain Entity
  factory EndorsementModel.fromEntity(Endorsement entity) {
    return EndorsementModel(
      userId: entity.userId,
      profilePicture: entity.profilePicture,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  /// Convert JSON to EndorsementModel
  factory EndorsementModel.fromJson(Map<String, dynamic> json) {
    return EndorsementModel(
      userId: json['_id'] as String,
      profilePicture: json['profilePicture'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  /// Convert EndorsementModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'profilePicture': profilePicture,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  /// Create a copy with modified fields
  EndorsementModel copyWith({
    String? userId,
    String? profilePicture,
  }) {
    return EndorsementModel(
      userId: userId ?? this.userId,
      profilePicture: profilePicture ?? this.profilePicture,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  List<Object?> get props => [userId, profilePicture, firstName, lastName];
}