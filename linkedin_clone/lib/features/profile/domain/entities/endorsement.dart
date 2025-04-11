import 'package:equatable/equatable.dart';

class Endorsement extends Equatable {
  final String userId;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;

  const Endorsement({
    required this.userId,
    this.profilePicture, 
    this.firstName,
    this.lastName,
  });

  Endorsement copyWith({
    String? userId,
    String? profilePicture,
    String? firstName,
    String? lastName,
  }) {
    return Endorsement(
      userId: userId ?? this.userId,
      profilePicture: profilePicture ?? this.profilePicture,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  List<Object?> get props => [userId, profilePicture, firstName, lastName]; // Nullable in props
}
