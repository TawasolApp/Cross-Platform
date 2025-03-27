import 'package:equatable/equatable.dart';

class Endorsement extends Equatable {
  final String userId;
  final String? profilePicUrl; // Nullable profile picture URL

  const Endorsement({
    required this.userId,
    this.profilePicUrl, // Now nullable
  });

  Endorsement copyWith({
    String? userId,
    String? profilePicUrl,
  }) {
    return Endorsement(
      userId: userId ?? this.userId,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    );
  }

  @override
  List<Object?> get props => [userId, profilePicUrl]; // Nullable in props
}
