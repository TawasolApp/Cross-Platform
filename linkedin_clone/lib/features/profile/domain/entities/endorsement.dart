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

  @override
  List<Object?> get props => [userId, profilePicture, firstName, lastName];
}
