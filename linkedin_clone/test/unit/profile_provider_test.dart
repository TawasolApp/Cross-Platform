// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
// import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_cover_photo.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_profile_picture.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_first_name.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_last_name.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
// import 'package:linkedin_clone/core/errors/failures.dart';
// import 'package:linkedin_clone/core/usecase/usecase.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_headline.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_industry.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_location.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_bio.dart';
// import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_resume.dart';

// // Mock classes for all use cases
// class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

// class MockAddExperienceUseCase extends Mock implements AddExperienceUseCase {}

// class MockUpdateExperienceUseCase extends Mock
//     implements UpdateExperienceUseCase {}

// class MockDeleteExperienceUseCase extends Mock
//     implements DeleteExperienceUseCase {}

// class MockAddSkillUseCase extends Mock implements AddSkillUseCase {}

// class MockUpdateSkillUseCase extends Mock implements UpdateSkillUseCase {}

// class MockDeleteSkillUseCase extends Mock implements DeleteSkillUseCase {}

// class MockAddEducationUseCase extends Mock implements AddEducationUseCase {}

// class MockUpdateEducationUseCase extends Mock
//     implements UpdateEducationUseCase {}

// class MockDeleteEducationUseCase extends Mock
//     implements DeleteEducationUseCase {}

// class MockAddCertificationUseCase extends Mock
//     implements AddCertificationUseCase {}

// class MockUpdateCertificationUseCase extends Mock
//     implements UpdateCertificationUseCase {}

// class MockDeleteCertificationUseCase extends Mock
//     implements DeleteCertificationUseCase {}

// class MockNoParams extends Mock implements NoParams {}

// class MockUpdateProfilePictureUseCase extends Mock
//     implements UpdateProfilePictureUseCase {}

// class MockDeleteProfilePictureUseCase extends Mock
//     implements DeleteProfilePictureUseCase {}

// class MockUpdateCoverPictureUseCase extends Mock
//     implements UpdateCoverPictureUseCase {}

// class MockDeleteCoverPhotoUseCase extends Mock
//     implements DeleteCoverPhotoUseCase {}

// class MockUpdateHeadlineUseCase extends Mock implements UpdateHeadlineUseCase {}

// class MockUpdateIndustryUseCase extends Mock implements UpdateIndustryUseCase {}

// class MockUpdateLocationUseCase extends Mock implements UpdateLocationUseCase {}

// class MockUpdateFirstNameUseCase extends Mock
//     implements UpdateFirstNameUseCase {}

// class MockUpdateLastNameUseCase extends Mock implements UpdateLastNameUseCase {}

// class MockUpdateResumeUseCase extends Mock implements UpdateResumeUseCase {}

// class MockDeleteHeadlineUseCase extends Mock implements DeleteHeadlineUseCase {}

// class MockDeleteIndustryUseCase extends Mock implements DeleteIndustryUseCase {}

// class MockDeleteLocationUseCase extends Mock implements DeleteLocationUseCase {}

// class MockDeleteBioUseCase extends Mock implements DeleteBioUseCase {}

// class MockDeleteResumeUseCase extends Mock implements DeleteResumeUseCase {}

// // Add missing mock parameter classes
// class MockExperienceUpdateParams extends Mock
//     implements ExperienceUpdateParams {}

// class MockEducationUpdateParams extends Mock implements EducationUpdateParams {}

// class MockCertificationUpdateParams extends Mock
//     implements CertificationUpdateParams {}

// class MockUpdateSkillParams extends Mock implements UpdateSkillParams {}

// // Custom mock for UpdateBioUseCase that doesn't use Mocktail
// class MockUpdateBioUseCase extends Mock implements UpdateBioUseCase {
//   @override
//   Future<Either<Failure, void>> call(BioParams params) async {
//     return Future.value(Right<Failure, void>(null));
//   }
// }

// // Test data
// const testExperience = Experience(
//   workExperienceId: 'exp1',
//   title: 'Flutter Developer',
//   company: 'Tech Co',
//   location: 'Remote',
//   startDate: '01/2020',
//   endDate: '12/2022',
//   description: 'Developed apps',
//   employmentType: 'Full-time',
//   locationType: 'Remote',
//   workExperiencePicture: 'https://example.com/techco.png',
// );

// const testEducation = Education(
//   educationId: 'edu1',
//   school: 'University',
//   degree: 'Bachelor',
//   field: 'Computer Science',
//   startDate: '08/2018',
//   endDate: '06/2022',
//   description: 'Studied CS',
//   grade: '3.7',
//   companyLogo: 'https://example.com/university.png',
// );

// const testSkill = Skill(skillName: 'Flutter', endorsements: []);

// const testCertification = Certification(
//   certificationId: 'cert1',
//   name: 'Flutter Certified',
//   company: 'Google',
//   issueDate: '03/2023',
//   companyLogo: 'https://example.com/google.png',
//   expiryDate: '03/2025',
// );

// // Mock profile data for testing
// final mockProfile = Profile(
//   userId: 'user123',
//   firstName: 'Test',
//   lastName: 'User',
//   profilePicture: 'profile.jpg',
//   coverPhoto: 'cover.jpg',
//   resume: 'resume.pdf',
//   headline: 'Flutter Developer',
//   bio: 'Experienced developer',
//   location: 'New York',
//   industry: 'Technology',
//   skills: [testSkill],
//   education: [testEducation],
//   certification: [testCertification],
//   workExperience: [testExperience],
//   visibility: 'public',
//   connectionCount: 500,
// );

// void main() {
//   late ProfileProvider provider;
//   late MockGetProfileUseCase mockGetProfile;
//   late MockAddExperienceUseCase mockAddExperience;
//   late MockUpdateExperienceUseCase mockUpdateExperience;
//   late MockDeleteExperienceUseCase mockDeleteExperience;
//   late MockAddSkillUseCase mockAddSkill;
//   late MockUpdateSkillUseCase mockUpdateSkill;
//   late MockDeleteSkillUseCase mockDeleteSkill;
//   late MockAddEducationUseCase mockAddEducation;
//   late MockUpdateEducationUseCase mockUpdateEducation;
//   late MockDeleteEducationUseCase mockDeleteEducation;
//   late MockAddCertificationUseCase mockAddCertification;
//   late MockUpdateCertificationUseCase mockUpdateCertification;
//   late MockDeleteCertificationUseCase mockDeleteCertification;
//   late MockUpdateBioUseCase mockUpdateBio;
//   late MockUpdateProfilePictureUseCase mockUpdateProfilePicture;
//   late MockDeleteProfilePictureUseCase mockDeleteProfilePicture;
//   late MockUpdateCoverPictureUseCase mockUpdateCoverPicture;
//   late MockDeleteCoverPhotoUseCase mockDeleteCoverPhoto;
//   late MockUpdateHeadlineUseCase mockUpdateHeadline;
//   late MockUpdateIndustryUseCase mockUpdateIndustry;
//   late MockUpdateLocationUseCase mockUpdateLocation;
//   late MockUpdateFirstNameUseCase mockUpdateFirstName;
//   late MockUpdateLastNameUseCase mockUpdateLastName;
//   late MockUpdateResumeUseCase mockUpdateResume;
//   late MockDeleteHeadlineUseCase mockDeleteHeadline;
//   late MockDeleteIndustryUseCase mockDeleteIndustry;
//   late MockDeleteLocationUseCase mockDeleteLocation;
//   late MockDeleteBioUseCase mockDeleteBio;
//   late MockDeleteResumeUseCase mockDeleteResume;

//   setUpAll(() {
//     registerFallbackValue(MockNoParams());
//     registerFallbackValue(
//       ExperienceUpdateParams(experienceId: 'exp1', experience: testExperience),
//     );
//     registerFallbackValue(
//       EducationUpdateParams(educationId: 'edu1', education: testEducation),
//     );
//     registerFallbackValue(
//       CertificationUpdateParams(
//         certificationId: 'cert1',
//         certification: testCertification,
//       ),
//     );
//     registerFallbackValue(BioParams(userId: 'user123', bio: 'test'));
//     registerFallbackValue(
//       UpdateSkillParams(
//         skillName: 'Flutter',
//         skill: const Skill(skillName: 'Flutter', position: '1'),
//       ),
//     );
//   });

//   setUp(() {
//     mockGetProfile = MockGetProfileUseCase();
//     mockAddExperience = MockAddExperienceUseCase();
//     mockUpdateExperience = MockUpdateExperienceUseCase();
//     mockDeleteExperience = MockDeleteExperienceUseCase();
//     mockAddSkill = MockAddSkillUseCase();
//     mockUpdateSkill = MockUpdateSkillUseCase();
//     mockDeleteSkill = MockDeleteSkillUseCase();
//     mockAddEducation = MockAddEducationUseCase();
//     mockUpdateEducation = MockUpdateEducationUseCase();
//     mockDeleteEducation = MockDeleteEducationUseCase();
//     mockAddCertification = MockAddCertificationUseCase();
//     mockUpdateCertification = MockUpdateCertificationUseCase();
//     mockDeleteCertification = MockDeleteCertificationUseCase();
//     mockUpdateBio = MockUpdateBioUseCase();
//     mockUpdateProfilePicture = MockUpdateProfilePictureUseCase();
//     mockDeleteProfilePicture = MockDeleteProfilePictureUseCase();
//     mockUpdateCoverPicture = MockUpdateCoverPictureUseCase();
//     mockDeleteCoverPhoto = MockDeleteCoverPhotoUseCase();
//     mockUpdateHeadline = MockUpdateHeadlineUseCase();
//     mockUpdateIndustry = MockUpdateIndustryUseCase();
//     mockUpdateLocation = MockUpdateLocationUseCase();
//     mockUpdateFirstName = MockUpdateFirstNameUseCase();
//     mockUpdateLastName = MockUpdateLastNameUseCase();
//     mockUpdateResume = MockUpdateResumeUseCase();
//     mockDeleteHeadline = MockDeleteHeadlineUseCase();
//     mockDeleteIndustry = MockDeleteIndustryUseCase();
//     mockDeleteLocation = MockDeleteLocationUseCase();
//     mockDeleteBio = MockDeleteBioUseCase();
//     mockDeleteResume = MockDeleteResumeUseCase();

//     provider = ProfileProvider(
//       getProfileUseCase: mockGetProfile,
//       updateProfilePictureUseCase: mockUpdateProfilePicture,
//       deleteProfilePictureUseCase: mockDeleteProfilePicture,
//       updateCoverPictureUseCase: mockUpdateCoverPicture,
//       deleteCoverPhotoUseCase: mockDeleteCoverPhoto,
//       updateHeadlineUseCase: mockUpdateHeadline,
//       updateIndustryUseCase: mockUpdateIndustry,
//       updateLocationUseCase: mockUpdateLocation,
//       updateFirstNameUseCase: mockUpdateFirstName,
//       updateLastNameUseCase: mockUpdateLastName,
//       updateResumeUseCase: mockUpdateResume,
//       deleteHeadlineUseCase: mockDeleteHeadline,
//       deleteIndustryUseCase: mockDeleteIndustry,
//       deleteLocationUseCase: mockDeleteLocation,
//       deleteBioUseCase: mockDeleteBio,
//       deleteResumeUseCase: mockDeleteResume,
//       updateBioUseCase: mockUpdateBio,
//       addExperienceUseCase: mockAddExperience,
//       updateExperienceUseCase: mockUpdateExperience,
//       deleteExperienceUseCase: mockDeleteExperience,
//       addSkillUseCase: mockAddSkill,
//       updateSkillUseCase: mockUpdateSkill,
//       deleteSkillUseCase: mockDeleteSkill,
//       addEducationUseCase: mockAddEducation,
//       updateEducationUseCase: mockUpdateEducation,
//       deleteEducationUseCase: mockDeleteEducation,
//       addCertificationUseCase: mockAddCertification,
//       updateCertificationUseCase: mockUpdateCertification,
//       deleteCertificationUseCase: mockDeleteCertification,
//     );
//   });

//   group('ProfileProvider', () {
//     test('should update state when profile is fetched successfully', () async {
//       // Arrange
//       when(
//         () => mockGetProfile(any()),
//       ).thenAnswer((_) => Future.value(Right(mockProfile)));

//       // Act
//       await provider.fetchProfile();

//       // Assert
//       expect(
//         provider.fullName,
//         '${mockProfile.firstName} ${mockProfile.lastName}',
//       );
//       expect(provider.bio, mockProfile.bio);
//       expect(provider.experiences, mockProfile.workExperience);
//       expect(provider.isLoading, false);
//       expect(provider.profileError, isNull);
//       verify(() => mockGetProfile(any())).called(1);
//     });

//     test('should set error when profile fetch fails', () async {
//       // Arrange
//       when(
//         () => mockGetProfile(any()),
//       ).thenAnswer((_) async => Left(ServerFailure()));

//       // Act
//       await provider.fetchProfile();

//       // Assert
//       expect(provider.profileError, isNotNull);
//       expect(provider.isLoading, false);
//       verify(() => mockGetProfile(any())).called(1);
//     });

//     group('Experience', () {
//       test('addExperience should add to state and call use case', () async {
//         // Arrange
//         when(
//           () => mockAddExperience(testExperience),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.addExperience(testExperience);

//         // Assert
//         expect(provider.experiences, contains(testExperience));
//         expect(provider.isLoading, false);
//         verify(() => mockAddExperience(testExperience)).called(1);
//       });

//       test('updateExperience should update state and call use case', () async {
//         // Arrange
//         provider.experiences = [testExperience];
//         provider.userId = 'user123';
//         final updatedExp = testExperience.copyWith(title: 'Senior Flutter Dev');

//         when(
//           () => mockUpdateExperience(any()),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.updateExperience(testExperience, updatedExp);

//         // Assert
//         expect(provider.experiences, contains(updatedExp));
//         expect(provider.experiences, isNot(contains(testExperience)));
//         expect(provider.isLoading, false);
//         verify(() => mockUpdateExperience(any())).called(1);
//       });

//       test(
//         'removeExperience should remove from state and call use case',
//         () async {
//           // Arrange
//           provider.experiences = [testExperience];
//           when(
//             () => mockDeleteExperience(testExperience.workExperienceId!),
//           ).thenAnswer((_) async => Right(null));

//           // Act
//           await provider.removeExperience(0);

//           // Assert
//           expect(provider.experiences, isEmpty);
//           expect(provider.isLoading, false);
//           verify(
//             () => mockDeleteExperience(testExperience.workExperienceId!),
//           ).called(1);
//         },
//       );
//     });

//     group('Education', () {
//       test('addEducation should add to state and call use case', () async {
//         // Arrange
//         when(
//           () => mockAddEducation(testEducation),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.addEducation(testEducation);

//         // Assert
//         expect(provider.educations, contains(testEducation));
//         expect(provider.isLoading, false);
//         verify(() => mockAddEducation(testEducation)).called(1);
//       });

//       test('updateEducation should update state and call use case', () async {
//         // Arrange
//         provider.educations = [testEducation];
//         provider.userId = 'user123';
//         final updatedEdu = testEducation.copyWith(degree: 'Master');

//         when(
//           () => mockUpdateEducation(any()),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.updateEducation(testEducation, updatedEdu);

//         // Assert
//         expect(provider.educations, contains(updatedEdu));
//         expect(provider.educations, isNot(contains(testEducation)));
//         expect(provider.isLoading, false);
//         verify(() => mockUpdateEducation(any())).called(1);
//       });

//       test(
//         'removeEducation should remove from state and call use case',
//         () async {
//           // Arrange
//           provider.educations = [testEducation];
//           when(
//             () => mockDeleteEducation(testEducation.educationId!),
//           ).thenAnswer((_) async => Right(null));

//           // Act
//           await provider.removeEducation(0);

//           // Assert
//           expect(provider.educations, isEmpty);
//           expect(provider.isLoading, false);
//           verify(
//             () => mockDeleteEducation(testEducation.educationId!),
//           ).called(1);
//         },
//       );
//     });

//     group('Skills', () {
//       test('addSkill should add to state and call use case', () async {
//         // Arrange
//         when(
//           () => mockAddSkill(testSkill),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.addSkill(testSkill);

//         // Assert
//         expect(provider.skills, contains(testSkill));
//         expect(provider.isLoading, false);
//         verify(() => mockAddSkill(testSkill)).called(1);
//       });

//       test('updateSkill should update state and call use case', () async {
//         // Arrange
//         provider.skills = [testSkill];
//         provider.userId = 'user123';
//         final updatedSkill = testSkill.copyWith(position: '1');

//         final updateParams = UpdateSkillParams(
//           skillName: testSkill.skillName,
//           skill: updatedSkill,
//         );

//         when(
//           () => mockUpdateSkill(any()),
//         ).thenAnswer((_) async => Right<Failure, void>(null));

//         // Act
//         await provider.updateSkill(0, updatedSkill);

//         // Assert
//         expect(provider.skills![0].position, '1');
//         expect(provider.isLoading, false);
//         verify(() => mockUpdateSkill(any())).called(1);
//       });

//       test('removeSkill should remove from state and call use case', () async {
//         // Arrange
//         provider.skills = [testSkill];
//         when(
//           () => mockDeleteSkill(testSkill.skillName),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.removeSkill(0);

//         // Assert
//         expect(provider.skills, isEmpty);
//         expect(provider.isLoading, false);
//         verify(() => mockDeleteSkill(testSkill.skillName)).called(1);
//       });
//     });

//     group('Certifications', () {
//       test('addCertification should add to state and call use case', () async {
//         // Arrange
//         when(
//           () => mockAddCertification(testCertification),
//         ).thenAnswer((_) async => Right(null));

//         // Act
//         await provider.addCertification(testCertification);

//         // Assert
//         expect(provider.certifications, contains(testCertification));
//         verify(() => mockAddCertification(testCertification)).called(1);
//       });

//       test(
//         'updateCertification should update state and call use case',
//         () async {
//           // Arrange
//           provider.certifications = [testCertification];
//           provider.userId = 'user123';
//           final updatedCert = testCertification.copyWith(
//             name: 'Advanced Flutter',
//           );

//           when(
//             () => mockUpdateCertification(any()),
//           ).thenAnswer((_) async => Right(null));

//           // Act
//           await provider.updateCertification(testCertification, updatedCert);

//           // Assert
//           expect(provider.certifications, contains(updatedCert));
//           expect(provider.certifications, isNot(contains(testCertification)));
//           expect(provider.isLoading, false);
//           verify(() => mockUpdateCertification(any())).called(1);
//         },
//       );

//       test(
//         'removeCertification should remove from state and call use case',
//         () async {
//           // Arrange
//           provider.certifications = [testCertification];
//           when(
//             () => mockDeleteCertification(testCertification.certificationId!),
//           ).thenAnswer((_) async => Right(null));

//           // Act
//           await provider.removeCertification(0);

//           // Assert
//           expect(provider.certifications, isEmpty);
//           verify(
//             () => mockDeleteCertification(testCertification.certificationId!),
//           ).called(1);
//         },
//       );
//     });

//     group('Bio', () {
//       test('setUserBio should update state and call use case', () async {
//         // Arrange
//         const newBio = 'Updated bio text';
//         provider.userId = 'user123';
//         final bioParams = BioParams(userId: 'user123', bio: newBio);

//         when(
//           () => mockUpdateBio.call(bioParams),
//         ).thenAnswer((_) async => Right<Failure, void>(null));

//         // Act
//         await provider.setUserBio(newBio);

//         // Assert
//         expect(provider.bio, newBio);
//         expect(provider.isLoading, false);
//         verify(() => mockUpdateBio.call(any())).called(1);
//       });

//       test('should handle error when updating bio fails', () async {
//         // Arrange
//         const newBio = 'Updated bio text';
//         provider.userId = 'user123';
//         final bioParams = BioParams(userId: 'user123', bio: newBio);

//         when(
//           () => mockUpdateBio.call(bioParams),
//         ).thenAnswer((_) async => Left<Failure, void>(ServerFailure()));

//         // Act
//         await provider.setUserBio(newBio);

//         // Assert
//         expect(provider.bioError, isNotNull);
//       });
//     });
//   });

//   group('Toggle Methods', () {
//     test('toggleExperienceExpansion should switch expansion state', () {
//       expect(provider.isExpandedExperiences, false);
//       provider.toggleExperienceExpansion();
//       expect(provider.isExpandedExperiences, true);
//       provider.toggleExperienceExpansion();
//       expect(provider.isExpandedExperiences, false);
//     });

//     test(
//       'toggleEducationExpansion should update education expansion state',
//       () {
//         expect(provider.isExpandedEducation, false);
//         provider.toggleEducationExpansion();
//         expect(provider.isExpandedEducation, true);
//         provider.toggleEducationExpansion();
//         expect(provider.isExpandedEducation, false);
//       },
//     );

//     test('toggleSkillsExpansion should update skills expansion state', () {
//       expect(provider.isExpandedSkills, false);
//       provider.toggleSkillsExpansion();
//       expect(provider.isExpandedSkills, true);
//       provider.toggleSkillsExpansion();
//       expect(provider.isExpandedSkills, false);
//     });

//     test(
//       'toggleCertificationExpansion should update certification expansion state',
//       () {
//         expect(provider.isExpandedCertifications, false);
//         provider.toggleCertificationExpansion();
//         expect(provider.isExpandedCertifications, true);
//         provider.toggleCertificationExpansion();
//         expect(provider.isExpandedCertifications, false);
//       },
//     );
//   });

//   group('Loading State', () {
//     test('should set loading state correctly', () {
//       expect(provider.isLoading, false);
//       provider.isLoading = true;
//       expect(provider.isLoading, true);
//       provider.isLoading = false;
//       expect(provider.isLoading, false);
//     });
//   });

//   group('Error Handling', () {
//     test('should set bio error correctly', () {
//       const errorMessage = 'Test error';
//       provider.bioError = errorMessage;
//       expect(provider.bioError, errorMessage);
//     });
//   });

//   test('toggleBioExpansion should update bio expansion state', () {
//     expect(provider.isExpandedBio, false);
//     provider.toggleBioExpansion();
//     expect(provider.isExpandedBio, true);
//     provider.toggleBioExpansion();
//     expect(provider.isExpandedBio, false);
//   });
// }
