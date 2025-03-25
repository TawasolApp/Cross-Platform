// import 'package:linkedin_clone/core/usecase/usecase.dart';
// import 'package:linkedin_clone/core/errors/failures.dart';
// import 'package:linkedin_clone/features/profile/domain/repositories/profile_repository.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
// import 'package:fpdart/fpdart.dart';

// class UpdateProfileUseCase implements UseCase<void, String> {
//   final ProfileRepository repository;

//   UpdateProfileUseCase(this.repository);

//   @override
//   Future<Either<Failure, void>> call({
//     String? name,
//     String? profilePictureUrl,
//     String? coverPhoto,
//     String? resume,
//     String? headline,
//     String? bio,
//     String? location,
//     String? industry,}) {
//     return repository.updateProfile(
//     name: name,
//     profilePictureUrl: profilePictureUrl,
//     coverPhoto: coverPhoto,
//     resume: resume,
//     headline: headline,
//     bio: bio,
//     location: location,
//     industry: industry);
//   }
// }
