import 'package:equatable/equatable.dart';

class UserPreviewEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  const UserPreviewEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  String get getId => id;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        profilePicture,
      ];
}
