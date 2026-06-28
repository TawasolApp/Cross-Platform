import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_cover_photo.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_first_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_last_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/get_skill_endorsements.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'profile_provider_test.mocks.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';

// Dummy value helpers
Either<Failure, T> dummyRight<T>(T value) => Right(value);
Either<Failure, T> dummyLeft<T>(Failure failure) => Left(failure);

void setupDummyValues() {
  // For Either<Failure, Profile>
  provideDummy<Either<Failure, Profile>>(
    dummyRight(
      Profile(
        userId: 'dummy',
        firstName: 'Dummy',
        lastName: 'User',
        skills: [],
        education: [],
        certification: [],
        workExperience: [],
        visibility: 'public',
        connectStatus: 'none',
        followStatus: 'none',
      ),
    ),
  );

  // For Either<Failure, void>
  provideDummy<Either<Failure, void>>(dummyRight(null));

  // For Either<Failure, List<Endorsement>>
  provideDummy<Either<Failure, List<Endorsement>>>(dummyRight([]));
}

@GenerateNiceMocks([
  MockSpec<GetProfileUseCase>(),
  MockSpec<UpdateProfilePictureUseCase>(),
  MockSpec<DeleteProfilePictureUseCase>(),
  MockSpec<UpdateCoverPictureUseCase>(),
  MockSpec<DeleteCoverPhotoUseCase>(),
  MockSpec<UpdateHeadlineUseCase>(),
  MockSpec<DeleteHeadlineUseCase>(),
  MockSpec<UpdateIndustryUseCase>(),
  MockSpec<DeleteIndustryUseCase>(),
  MockSpec<UpdateLocationUseCase>(),
  MockSpec<DeleteLocationUseCase>(),
  MockSpec<UpdateFirstNameUseCase>(),
  MockSpec<UpdateLastNameUseCase>(),
  MockSpec<UpdateResumeUseCase>(),
  MockSpec<DeleteResumeUseCase>(),
  MockSpec<UpdateBioUseCase>(),
  MockSpec<DeleteBioUseCase>(),
  MockSpec<AddExperienceUseCase>(),
  MockSpec<UpdateExperienceUseCase>(),
  MockSpec<DeleteExperienceUseCase>(),
  MockSpec<AddSkillUseCase>(),
  MockSpec<DeleteSkillUseCase>(),
  MockSpec<AddEducationUseCase>(),
  MockSpec<UpdateEducationUseCase>(),
  MockSpec<DeleteEducationUseCase>(),
  MockSpec<AddCertificationUseCase>(),
  MockSpec<UpdateCertificationUseCase>(),
  MockSpec<DeleteCertificationUseCase>(),
  MockSpec<UpdateSkillUseCase>(),
  MockSpec<GetSkillEndorsements>(),
])
void main() {
  late ProfileProvider profileProvider;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfilePictureUseCase mockUpdateProfilePictureUseCase;
  late MockDeleteProfilePictureUseCase mockDeleteProfilePictureUseCase;
  late MockUpdateCoverPictureUseCase mockUpdateCoverPictureUseCase;
  late MockDeleteCoverPhotoUseCase mockDeleteCoverPhotoUseCase;
  late MockUpdateHeadlineUseCase mockUpdateHeadlineUseCase;
  late MockDeleteHeadlineUseCase mockDeleteHeadlineUseCase;
  late MockUpdateIndustryUseCase mockUpdateIndustryUseCase;
  late MockDeleteIndustryUseCase mockDeleteIndustryUseCase;
  late MockUpdateLocationUseCase mockUpdateLocationUseCase;
  late MockDeleteLocationUseCase mockDeleteLocationUseCase;
  late MockUpdateFirstNameUseCase mockUpdateFirstNameUseCase;
  late MockUpdateLastNameUseCase mockUpdateLastNameUseCase;
  late MockUpdateResumeUseCase mockUpdateResumeUseCase;
  late MockDeleteResumeUseCase mockDeleteResumeUseCase;
  late MockUpdateBioUseCase mockUpdateBioUseCase;
  late MockDeleteBioUseCase mockDeleteBioUseCase;
  late MockAddExperienceUseCase mockAddExperienceUseCase;
  late MockUpdateExperienceUseCase mockUpdateExperienceUseCase;
  late MockDeleteExperienceUseCase mockDeleteExperienceUseCase;
  late MockAddSkillUseCase mockAddSkillUseCase;
  late MockDeleteSkillUseCase mockDeleteSkillUseCase;
  late MockAddEducationUseCase mockAddEducationUseCase;
  late MockUpdateEducationUseCase mockUpdateEducationUseCase;
  late MockDeleteEducationUseCase mockDeleteEducationUseCase;
  late MockAddCertificationUseCase mockAddCertificationUseCase;
  late MockUpdateCertificationUseCase mockUpdateCertificationUseCase;
  late MockDeleteCertificationUseCase mockDeleteCertificationUseCase;
  late MockUpdateSkillUseCase mockUpdateSkillUseCase;
  late MockGetSkillEndorsements mockGetSkillEndorsementsUseCase;

  final testProfile = Profile(
    userId: 'testUserId',
    firstName: 'John',
    lastName: 'Doe',
    profilePicture: 'profile.jpg',
    coverPhoto: 'cover.jpg',
    headline: 'Software Developer',
    bio: 'Test bio',
    location: 'Test Location',
    industry: 'Test Industry',
    skills: [Skill(skillName: 'Flutter'), Skill(skillName: 'Dart')],
    education: [
      Education(
        school: 'Test University',
        degree: 'Bachelor',
        field: 'Computer Science',
      ),
    ],
    certification: [
      Certification(
        name: 'Test Certification',
        company: 'Test Company',
        issueDate: '2020-01-01',
      ),
    ],
    workExperience: [
      Experience(
        title: 'Software Engineer',
        company: 'Test Company',
        startDate: '2018-01-01',
        employmentType: 'Full-time',
      ),
    ],
    visibility: 'public',
    connectionCount: 100,
    connectStatus: 'Connected',
    followStatus: 'Following',
  );

  setUp(() {
    setupDummyValues();

    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfilePictureUseCase = MockUpdateProfilePictureUseCase();
    mockDeleteProfilePictureUseCase = MockDeleteProfilePictureUseCase();
    mockUpdateCoverPictureUseCase = MockUpdateCoverPictureUseCase();
    mockDeleteCoverPhotoUseCase = MockDeleteCoverPhotoUseCase();
    mockUpdateHeadlineUseCase = MockUpdateHeadlineUseCase();
    mockDeleteHeadlineUseCase = MockDeleteHeadlineUseCase();
    mockUpdateIndustryUseCase = MockUpdateIndustryUseCase();
    mockDeleteIndustryUseCase = MockDeleteIndustryUseCase();
    mockUpdateLocationUseCase = MockUpdateLocationUseCase();
    mockDeleteLocationUseCase = MockDeleteLocationUseCase();
    mockUpdateFirstNameUseCase = MockUpdateFirstNameUseCase();
    mockUpdateLastNameUseCase = MockUpdateLastNameUseCase();
    mockUpdateResumeUseCase = MockUpdateResumeUseCase();
    mockDeleteResumeUseCase = MockDeleteResumeUseCase();
    mockUpdateBioUseCase = MockUpdateBioUseCase();
    mockDeleteBioUseCase = MockDeleteBioUseCase();
    mockAddExperienceUseCase = MockAddExperienceUseCase();
    mockUpdateExperienceUseCase = MockUpdateExperienceUseCase();
    mockDeleteExperienceUseCase = MockDeleteExperienceUseCase();
    mockAddSkillUseCase = MockAddSkillUseCase();
    mockDeleteSkillUseCase = MockDeleteSkillUseCase();
    mockAddEducationUseCase = MockAddEducationUseCase();
    mockUpdateEducationUseCase = MockUpdateEducationUseCase();
    mockDeleteEducationUseCase = MockDeleteEducationUseCase();
    mockAddCertificationUseCase = MockAddCertificationUseCase();
    mockUpdateCertificationUseCase = MockUpdateCertificationUseCase();
    mockDeleteCertificationUseCase = MockDeleteCertificationUseCase();
    mockUpdateSkillUseCase = MockUpdateSkillUseCase();
    mockGetSkillEndorsementsUseCase = MockGetSkillEndorsements();

    profileProvider = ProfileProvider(
      getProfileUseCase: mockGetProfileUseCase,
      updateProfilePictureUseCase: mockUpdateProfilePictureUseCase,
      deleteProfilePictureUseCase: mockDeleteProfilePictureUseCase,
      updateCoverPictureUseCase: mockUpdateCoverPictureUseCase,
      deleteCoverPhotoUseCase: mockDeleteCoverPhotoUseCase,
      updateHeadlineUseCase: mockUpdateHeadlineUseCase,
      deleteHeadlineUseCase: mockDeleteHeadlineUseCase,
      updateIndustryUseCase: mockUpdateIndustryUseCase,
      deleteIndustryUseCase: mockDeleteIndustryUseCase,
      updateLocationUseCase: mockUpdateLocationUseCase,
      deleteLocationUseCase: mockDeleteLocationUseCase,
      updateFirstNameUseCase: mockUpdateFirstNameUseCase,
      updateLastNameUseCase: mockUpdateLastNameUseCase,
      updateResumeUseCase: mockUpdateResumeUseCase,
      deleteResumeUseCase: mockDeleteResumeUseCase,
      updateBioUseCase: mockUpdateBioUseCase,
      deleteBioUseCase: mockDeleteBioUseCase,
      addExperienceUseCase: mockAddExperienceUseCase,
      updateExperienceUseCase: mockUpdateExperienceUseCase,
      deleteExperienceUseCase: mockDeleteExperienceUseCase,
      addEducationUseCase: mockAddEducationUseCase,
      updateEducationUseCase: mockUpdateEducationUseCase,
      deleteEducationUseCase: mockDeleteEducationUseCase,
      addCertificationUseCase: mockAddCertificationUseCase,
      updateCertificationUseCase: mockUpdateCertificationUseCase,
      deleteCertificationUseCase: mockDeleteCertificationUseCase,
      updateSkillUseCase: mockUpdateSkillUseCase,
      addSkillUseCase: mockAddSkillUseCase,
      deleteSkillUseCase: mockDeleteSkillUseCase,
      getSkillEndorsementsUseCase: mockGetSkillEndorsementsUseCase,
    );
  });

  group('ProfileProvider Tests', () {
    test('Initial state', () {
      expect(profileProvider.userId, isNull);
      expect(profileProvider.firstName, isNull);
      expect(profileProvider.lastName, isNull);
      expect(profileProvider.isLoading, false);
    });

    group('fetchProfile', () {
      test('should set profile data when successful', () async {
        // Arrange
        when(
          mockGetProfileUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(testProfile));

        // Act
        await profileProvider.fetchProfile('testUserId');

        // Assert
        expect(profileProvider.userId, 'testUserId');
        expect(profileProvider.firstName, 'John');
        expect(profileProvider.lastName, 'Doe');
        expect(profileProvider.profilePicture, 'profile.jpg');
        expect(profileProvider.headline, 'Software Developer');
        expect(profileProvider.skills?.length, 2);
        expect(profileProvider.experiences?.length, 1);
        expect(profileProvider.isLoading, false);
      });
    });

    group('Profile Picture', () {
      test(
        'deleteProfilePicture should remove profile picture when successful',
        () async {
          // Arrange
          when(
            mockDeleteProfilePictureUseCase.call(any),
          ).thenAnswer((_) async => dummyRight(null));
          profileProvider.profilePicture = 'profile.jpg';

          // Act
          await profileProvider.deleteProfilePicture();

          // Assert
          verify(mockDeleteProfilePictureUseCase.call(any)).called(1);
          expect(profileProvider.profilePicture, isNull);
        },
      );
    });

    group('Cover Photo', () {
      test(
        'deleteCoverPhoto should remove cover photo when successful',
        () async {
          // Arrange
          when(
            mockDeleteCoverPhotoUseCase.call(any),
          ).thenAnswer((_) async => dummyRight(null));
          profileProvider.coverPhoto = 'cover.jpg';

          // Act
          await profileProvider.deleteCoverPhoto();

          // Assert
          verify(mockDeleteCoverPhotoUseCase.call(any)).called(1);
          expect(profileProvider.coverPhoto, isNull);
        },
      );
    });

    group('Headline', () {
      test('deleteHeadline should remove headline when successful', () async {
        // Arrange
        when(
          mockDeleteHeadlineUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));
        profileProvider.headline = 'Old Headline';

        // Act
        await profileProvider.deleteHeadline();

        // Assert
        verify(mockDeleteHeadlineUseCase.call(any)).called(1);
        expect(profileProvider.headline, isNull);
      });
    });

    group('Bio', () {
      test('deleteBio should remove bio when successful', () async {
        // Arrange
        when(
          mockDeleteBioUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));
        profileProvider.bio = 'Old Bio';

        // Act
        await profileProvider.deleteBio();

        // Assert
        verify(mockDeleteBioUseCase.call(any)).called(1);
        expect(profileProvider.bio, isNull);
      });
    });

    group('Experience', () {
      final testExperience = Experience(
        title: 'Software Engineer',
        company: 'Test Company',
        startDate: '2020-01-01',
        employmentType: 'Full-time',
      );

      test('addExperience should add experience when successful', () async {
        // Arrange
        when(
          mockAddExperienceUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));

        // Act
        await profileProvider.addExperience(testExperience);

        // Assert
        verify(mockAddExperienceUseCase.call(testExperience)).called(1);
        expect(profileProvider.experiences?.length, 1);
      });

      test(
        'updateExperience should update experience when successful',
        () async {
          // Arrange
          when(
            mockUpdateExperienceUseCase.call(any),
          ).thenAnswer((_) async => dummyRight(null));
          profileProvider.experiences = [testExperience];
          final updatedExperience = testExperience.copyWith(
            title: 'Senior Software Engineer',
          );

          // Act
          await profileProvider.updateExperience(
            testExperience,
            updatedExperience,
          );

          // Assert
          verify(mockUpdateExperienceUseCase.call(any)).called(1);
          expect(
            profileProvider.experiences?[0].title,
            'Senior Software Engineer',
          );
        },
      );
    });

    group('Education', () {
      final testEducation = Education(
        school: 'Test University',
        degree: 'Bachelor',
        field: 'Computer Science',
      );

      test('addEducation should add education when successful', () async {
        // Arrange
        when(
          mockAddEducationUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));

        // Act
        await profileProvider.addEducation(testEducation);

        // Assert
        verify(mockAddEducationUseCase.call(testEducation)).called(1);
        expect(profileProvider.educations?.length, 1);
      });

      test('updateEducation should update education when successful', () async {
        // Arrange
        when(
          mockUpdateEducationUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));
        profileProvider.educations = [testEducation];
        final updatedEducation = testEducation.copyWith(degree: 'Master');

        // Act
        await profileProvider.updateEducation(testEducation, updatedEducation);

        // Assert
        verify(mockUpdateEducationUseCase.call(any)).called(1);
        expect(profileProvider.educations?[0].degree, 'Master');
      });
    });

    group('Skills', () {
      final testSkill = Skill(skillName: 'Flutter');

      test('addSkill should add skill when successful', () async {
        // Arrange
        when(
          mockAddSkillUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));

        // Act
        await profileProvider.addSkill(testSkill);

        // Assert
        verify(mockAddSkillUseCase.call(testSkill)).called(1);
        expect(profileProvider.skills?.length, 1);
      });

      test('removeSkill should remove skill when successful', () async {
        // Arrange
        when(
          mockDeleteSkillUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));
        profileProvider.skills = [testSkill];

        // Act
        await profileProvider.removeSkill(0);

        // Assert
        verify(mockDeleteSkillUseCase.call('Flutter')).called(1);
        expect(profileProvider.skills?.length, 0);
      });

      test('updateSkill should update skill when successful', () async {
        // Arrange
        when(
          mockUpdateSkillUseCase.call(any),
        ).thenAnswer((_) async => dummyRight(null));
        profileProvider.skills = [testSkill];
        final updatedSkill = testSkill.copyWith(position: '1');

        // Act
        await profileProvider.updateSkill(0, updatedSkill);

        // Assert
        verify(mockUpdateSkillUseCase.call(any)).called(1);
        expect(profileProvider.skills?[0].position, '1');
      });
    });

    group('Certifications', () {
      final testCertification = Certification(
        name: 'Test Certification',
        company: 'Test Company',
        issueDate: '2020-01-01',
      );

      test(
        'addCertification should add certification when successful',
        () async {
          // Arrange
          when(
            mockAddCertificationUseCase.call(any),
          ).thenAnswer((_) async => dummyRight(null));

          // Act
          await profileProvider.addCertification(testCertification);

          // Assert
          verify(mockAddCertificationUseCase.call(testCertification)).called(1);
          expect(profileProvider.certifications?.length, 1);
        },
      );

      test(
        'updateCertification should update certification when successful',
        () async {
          // Arrange
          when(
            mockUpdateCertificationUseCase.call(any),
          ).thenAnswer((_) async => dummyRight(null));
          profileProvider.certifications = [testCertification];
          final updatedCertification = testCertification.copyWith(
            name: 'Updated Certification',
          );

          // Act
          await profileProvider.updateCertification(
            testCertification,
            updatedCertification,
          );

          // Assert
          verify(mockUpdateCertificationUseCase.call(any)).called(1);
          expect(
            profileProvider.certifications?[0].name,
            'Updated Certification',
          );
        },
      );
    });

    group('Skill Endorsements', () {
      final testEndorsements = [
        Endorsement(userId: 'user1', firstName: 'Alice', lastName: 'Smith'),
        Endorsement(userId: 'user2', firstName: 'Bob', lastName: 'Johnson'),
      ];
    });

    group('Expansion Toggles', () {
      test('toggleBioExpansion should toggle bio expansion state', () {
        // Initial state
        expect(profileProvider.isExpandedBio, false);

        // First toggle
        profileProvider.toggleBioExpansion();
        expect(profileProvider.isExpandedBio, true);

        // Second toggle
        profileProvider.toggleBioExpansion();
        expect(profileProvider.isExpandedBio, false);
      });

      test(
        'toggleExperienceExpansion should toggle experiences expansion state',
        () {
          expect(profileProvider.isExpandedExperiences, false);
          profileProvider.toggleExperienceExpansion();
          expect(profileProvider.isExpandedExperiences, true);
          profileProvider.toggleExperienceExpansion();
          expect(profileProvider.isExpandedExperiences, false);
        },
      );
    });
  });
}
