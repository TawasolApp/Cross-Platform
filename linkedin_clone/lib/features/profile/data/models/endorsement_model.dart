import 'package:equatable/equatable.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';

class EndorsementModel extends Endorsement with EquatableMixin {
  EndorsementModel({
    required super.userId,
    super.profilePicUrl,
  });

  factory EndorsementModel.fromJson(Map<String, dynamic> json) {
    return EndorsementModel(
      userId: json['userId'] as String,
      profilePicUrl: json['profilePicUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profilePicUrl': profilePicUrl,
    };
  }

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
