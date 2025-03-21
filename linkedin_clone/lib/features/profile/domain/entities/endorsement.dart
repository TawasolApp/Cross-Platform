import 'package:equatable/equatable.dart';

class Endorsement extends Equatable {
  final String userId;
  final String? profilePicUrl; // Nullable profile picture URL

  const Endorsement({
    required this.userId,
    this.profilePicUrl, // Now nullable
  });

  @override
  List<Object?> get props => [userId, profilePicUrl]; // Nullable in props
}
