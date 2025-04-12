import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
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
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_first_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_last_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/get_skill_endorsements.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfilePictureUseCase extends Mock
    implements UpdateProfilePictureUseCase {}

class MockDeleteProfilePictureUseCase extends Mock
    implements DeleteProfilePictureUseCase {}

class MockUpdateCoverPictureUseCase extends Mock
    implements UpdateCoverPictureUseCase {}

class MockDeleteCoverPhotoUseCase extends Mock
    implements DeleteCoverPhotoUseCase {}

class MockUpdateHeadlineUseCase extends Mock implements UpdateHeadlineUseCase {}

class MockDeleteHeadlineUseCase extends Mock implements DeleteHeadlineUseCase {}

class MockUpdateIndustryUseCase extends Mock implements UpdateIndustryUseCase {}

class MockDeleteIndustryUseCase extends Mock implements DeleteIndustryUseCase {}

class MockUpdateLocationUseCase extends Mock implements UpdateLocationUseCase {}

class MockDeleteLocationUseCase extends Mock implements DeleteLocationUseCase {}

class MockUpdateFirstNameUseCase extends Mock
    implements UpdateFirstNameUseCase {}

class MockUpdateLastNameUseCase extends Mock implements UpdateLastNameUseCase {}

class MockUpdateResumeUseCase extends Mock implements UpdateResumeUseCase {}

class MockDeleteResumeUseCase extends Mock implements DeleteResumeUseCase {}

class MockUpdateBioUseCase extends Mock implements UpdateBioUseCase {}

class MockDeleteBioUseCase extends Mock implements DeleteBioUseCase {}

class MockAddExperienceUseCase extends Mock implements AddExperienceUseCase {}

class MockUpdateExperienceUseCase extends Mock
    implements UpdateExperienceUseCase {}

class MockDeleteExperienceUseCase extends Mock
    implements DeleteExperienceUseCase {}

class MockAddEducationUseCase extends Mock implements AddEducationUseCase {}

class MockUpdateEducationUseCase extends Mock
    implements UpdateEducationUseCase {}

class MockDeleteEducationUseCase extends Mock
    implements DeleteEducationUseCase {}

class MockAddCertificationUseCase extends Mock
    implements AddCertificationUseCase {}

class MockUpdateCertificationUseCase extends Mock
    implements UpdateCertificationUseCase {}

class MockDeleteCertificationUseCase extends Mock
    implements DeleteCertificationUseCase {}

class MockAddSkillUseCase extends Mock implements AddSkillUseCase {}

class MockDeleteSkillUseCase extends Mock implements DeleteSkillUseCase {}

class MockUpdateSkillUseCase extends Mock implements UpdateSkillUseCase {}

class MockGetSkillEndorsementsUseCase extends Mock
    implements GetSkillEndorsements {}

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
  late MockAddEducationUseCase mockAddEducationUseCase;
  late MockUpdateEducationUseCase mockUpdateEducationUseCase;
  late MockDeleteEducationUseCase mockDeleteEducationUseCase;
  late MockAddCertificationUseCase mockAddCertificationUseCase;
  late MockUpdateCertificationUseCase mockUpdateCertificationUseCase;
  late MockDeleteCertificationUseCase mockDeleteCertificationUseCase;
  late MockAddSkillUseCase mockAddSkillUseCase;
  late MockDeleteSkillUseCase mockDeleteSkillUseCase;
  late MockUpdateSkillUseCase mockUpdateSkillUseCase;
  late MockGetSkillEndorsementsUseCase mockGetSkillEndorsementsUseCase;

  setUp(() {
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
    mockAddEducationUseCase = MockAddEducationUseCase();
    mockUpdateEducationUseCase = MockUpdateEducationUseCase();
    mockDeleteEducationUseCase = MockDeleteEducationUseCase();
    mockAddCertificationUseCase = MockAddCertificationUseCase();
    mockUpdateCertificationUseCase = MockUpdateCertificationUseCase();
    mockDeleteCertificationUseCase = MockDeleteCertificationUseCase();
    mockAddSkillUseCase = MockAddSkillUseCase();
    mockDeleteSkillUseCase = MockDeleteSkillUseCase();
    mockUpdateSkillUseCase = MockUpdateSkillUseCase();
    mockGetSkillEndorsementsUseCase = MockGetSkillEndorsementsUseCase();

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
    // Add userId to provider for tests that need it
    profileProvider.userId = 'test123';
  });

  group('ProfileProvider Tests', () {
    final testProfile = Profile(
      userId: 'test123',
      firstName: 'John',
      lastName: 'Doe',
      profilePicture: 'profile.jpg',
      coverPhoto: 'cover.jpg',
      resume: 'resume.pdf',
      headline: 'Software Engineer',
      bio: 'Experienced developer',
      location: 'New York',
      industry: 'Technology',
      skills: [
        Skill(
          skillName: 'Flutter',
          endorsements: ['user1', 'user2', 'user3', 'user4', 'user5'],
        ),
        Skill(skillName: 'Dart', endorsements: ['user1', 'user2', 'user3']),
      ],
      education: [
        Education(
          school: 'University',
          degree: 'BSc',
          field: 'Computer Science', // Changed from fieldOfStudy to field
          startDate: '2015-09',
          endDate: '2019-06',
        ),
      ],
      certification: [
        Certification(
          name: 'Flutter Certification',
          company: 'Google', // Changed from issuingOrganization to company
          issueDate: '2020-01', // Changed from issueDate
          expiryDate: '2022-01', // Changed from expirationDate to expiryDate
        ),
      ],
      workExperience: [
        Experience(
          title: 'Developer',
          company: 'Tech Corp',
          startDate: '2019-07',
          endDate: '2021-12',
          employmentType: 'Full-time', // Added required field
        ),
      ],
      visibility: 'public',
      connectionCount: 150,
      connectStatus: 'connected',
      followStatus: 'following',
    );

    test('initial state', () {
      expect(profileProvider.userId, isNull);
      expect(profileProvider.firstName, isNull);
      expect(profileProvider.lastName, isNull);
      expect(profileProvider.profilePicture, isNull);
      expect(profileProvider.coverPhoto, isNull);
      expect(profileProvider.resume, isNull);
      expect(profileProvider.headline, isNull);
      expect(profileProvider.bio, isNull);
      expect(profileProvider.location, isNull);
      expect(profileProvider.industry, isNull);
      expect(profileProvider.skills, isNull);
      expect(profileProvider.educations, isNull);
      expect(profileProvider.certifications, isNull);
      expect(profileProvider.experiences, isNull);
      expect(profileProvider.visibility, isNull);
      expect(profileProvider.connectionCount, isNull);
      expect(profileProvider.connectStatus, isNull);
      expect(profileProvider.followStatus, isNull);
      expect(profileProvider.isLoading, false);
      expect(profileProvider.isLoadingEndorsements, false);
    });

    group('fetchProfile', () {
      test('should update state with profile data on success', () async {
        // Arrange
        when(
          mockGetProfileUseCase.call(any),
        ).thenAnswer((_) async => Right(testProfile));

        // Act
        await profileProvider.fetchProfile('test123');

        // Assert
        expect(profileProvider.userId, 'test123');
        expect(profileProvider.firstName, 'John');
        expect(profileProvider.lastName, 'Doe');
        expect(profileProvider.profilePicture, 'profile.jpg');
        expect(profileProvider.coverPhoto, 'cover.jpg');
        expect(profileProvider.resume, 'resume.pdf');
        expect(profileProvider.headline, 'Software Engineer');
        expect(profileProvider.bio, 'Experienced developer');
        expect(profileProvider.location, 'New York');
        expect(profileProvider.industry, 'Technology');
        expect(profileProvider.skills?.length, 2);
        expect(profileProvider.educations?.length, 1);
        expect(profileProvider.certifications?.length, 1);
        expect(profileProvider.experiences?.length, 1);
        expect(profileProvider.visibility, 'public');
        expect(profileProvider.connectionCount, 150);
        expect(profileProvider.connectStatus, 'connected');
        expect(profileProvider.followStatus, 'following');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('should set error on failure', () async {
        // Arrange
        when(
          mockGetProfileUseCase.call(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // Act
        await profileProvider.fetchProfile('test123');

        // Assert
        expect(profileProvider.profileError, isNotNull);
        expect(profileProvider.isLoading, false);
      });
    });

    group('Profile Picture', () {
      test('updateProfilePicture should update state on success', () async {
        // Arrange
        when(
          mockUpdateProfilePictureUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateProfilePicture('new_profile.jpg');

        // Assert
        expect(profileProvider.profilePicture, 'new_profile.jpg');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test(
        'deleteProfilePicture should clear profile picture on success',
        () async {
          // Arrange
          profileProvider.profilePicture = 'profile.jpg';
          when(
            mockDeleteProfilePictureUseCase.call(any),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await profileProvider.deleteProfilePicture();

          // Assert
          expect(profileProvider.profilePicture, isNull);
          expect(profileProvider.isLoading, false);
          expect(profileProvider.profileError, isNull);
        },
      );
    });

    group('Cover Photo', () {
      test('updateCoverPhoto should update state on success', () async {
        // Arrange
        when(
          mockUpdateCoverPictureUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateCoverPhoto('new_cover.jpg');

        // Assert
        expect(profileProvider.coverPhoto, 'new_cover.jpg');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('deleteCoverPhoto should clear cover photo on success', () async {
        // Arrange
        profileProvider.coverPhoto = 'cover.jpg';
        when(
          mockDeleteCoverPhotoUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteCoverPhoto();

        // Assert
        expect(profileProvider.coverPhoto, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });
    });

    group('Headline', () {
      test('updateHeadline should update state on success', () async {
        // Arrange
        when(
          mockUpdateHeadlineUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateHeadline('New Headline');

        // Assert
        expect(profileProvider.headline, 'New Headline');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('deleteHeadline should clear headline on success', () async {
        // Arrange
        profileProvider.headline = 'Current Headline';
        when(
          mockDeleteHeadlineUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteHeadline();

        // Assert
        expect(profileProvider.headline, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });
    });

    group('Industry', () {
      test('updateIndustry should update state on success', () async {
        // Arrange
        when(
          mockUpdateIndustryUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateIndustry('New Industry');

        // Assert
        expect(profileProvider.industry, 'New Industry');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('deleteIndustry should clear industry on success', () async {
        // Arrange
        profileProvider.industry = 'Current Industry';
        when(
          mockDeleteIndustryUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteIndustry();

        // Assert
        expect(profileProvider.industry, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });
    });

    group('Location', () {
      test('updateLocation should update state on success', () async {
        // Arrange
        when(
          mockUpdateLocationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateLocation('New Location');

        // Assert
        expect(profileProvider.location, 'New Location');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('deleteLocation should clear location on success', () async {
        // Arrange
        profileProvider.location = 'Current Location';
        when(
          mockDeleteLocationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteLocation();

        // Assert
        expect(profileProvider.location, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });
    });

    group('Name', () {
      test('updateFirstName should update state on success', () async {
        // Arrange
        when(
          mockUpdateFirstNameUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateFirstName('Jane');

        // Assert
        expect(profileProvider.firstName, 'Jane');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });

      test('updateLastName should update state on success', () async {
        // Arrange
        when(
          mockUpdateLastNameUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateLastName('Smith');

        // Assert
        expect(profileProvider.lastName, 'Smith');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.profileError, isNull);
      });
    });

    group('Resume', () {
      test('updateResume should update state on success', () async {
        // Arrange
        when(
          mockUpdateResumeUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateResume('new_resume.pdf');

        // Assert
        expect(profileProvider.resume, 'new_resume.pdf');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.resumeError, isNull);
      });

      test('deleteResume should clear resume on success', () async {
        // Arrange
        profileProvider.resume = 'current_resume.pdf';
        when(
          mockDeleteResumeUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteResume();

        // Assert
        expect(profileProvider.resume, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.resumeError, isNull);
      });
    });

    group('Bio', () {
      test('setUserBio should update state on success', () async {
        // Arrange
        when(
          mockUpdateBioUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.setUserBio('New bio text');

        // Assert
        expect(profileProvider.bio, 'New bio text');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.bioError, isNull);
      });

      test('deleteBio should clear bio on success', () async {
        // Arrange
        profileProvider.bio = 'Current bio';
        when(
          mockDeleteBioUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.deleteBio();

        // Assert
        expect(profileProvider.bio, isNull);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.bioError, isNull);
      });
    });

    group('Experience', () {
      final testExperience = Experience(
        title: 'Developer',
        company: 'Tech Corp',
        startDate: '2019-07',
        endDate: '2021-12',
        employmentType: 'Full-time',
        workExperienceId: 'exp123', // Add ID for the tests to work
      );

      test('addExperience should add experience on success', () async {
        // Arrange
        when(
          mockAddExperienceUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.addExperience(testExperience);

        // Assert
        expect(profileProvider.experiences?.length, 1);
        expect(profileProvider.experiences?[0].title, 'Developer');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.experienceError, isNull);
      });

      test('removeExperience should remove experience on success', () async {
        // Arrange
        profileProvider.experiences = [testExperience];
        when(
          mockDeleteExperienceUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.removeExperience(0);

        // Assert
        expect(profileProvider.experiences?.length, 0);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.experienceError, isNull);
      });

      test('updateExperience should update experience on success', () async {
        // Arrange
        final oldExperience = testExperience;
        final newExperience = testExperience.copyWith(
          title: 'Senior Developer',
        );
        profileProvider.experiences = [oldExperience];
        when(
          mockUpdateExperienceUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateExperience(oldExperience, newExperience);

        // Assert
        expect(profileProvider.experiences?[0].title, 'Senior Developer');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.experienceError, isNull);
      });
    });

    group('Education', () {
      final testEducation = Education(
        educationId: 'edu123', // Add ID for tests to work
        school: 'University',
        degree: 'BSc',
        field: 'Computer Science', // Changed from fieldOfStudy to field
        startDate: '2015-09',
        endDate: '2019-06',
      );

      test('addEducation should add education on success', () async {
        // Arrange
        when(
          mockAddEducationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.addEducation(testEducation);

        // Assert
        expect(profileProvider.educations?.length, 1);
        expect(profileProvider.educations?[0].school, 'University');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.educationError, isNull);
      });

      test('removeEducation should remove education on success', () async {
        // Arrange
        profileProvider.educations = [testEducation];
        when(
          mockDeleteEducationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.removeEducation(0);

        // Assert
        expect(profileProvider.educations?.length, 0);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.educationError, isNull);
      });

      test('updateEducation should update education on success', () async {
        // Arrange
        final oldEducation = testEducation;
        final newEducation = testEducation.copyWith(degree: 'MSc');
        profileProvider.educations = [oldEducation];
        when(
          mockUpdateEducationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateEducation(oldEducation, newEducation);

        // Assert
        expect(profileProvider.educations?[0].degree, 'MSc');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.educationError, isNull);
      });
    });

    group('Certification', () {
      final testCertification = Certification(
        certificationId: 'cert123', // Add ID for tests to work
        name: 'Flutter Certification',
        company: 'Google', // Changed from issuingOrganization to company
        issueDate: '2020-01',
        expiryDate: '2022-01', // Changed from expirationDate to expiryDate
      );

      test('addCertification should add certification on success', () async {
        // Arrange
        when(
          mockAddCertificationUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.addCertification(testCertification);

        // Assert
        expect(profileProvider.certifications?.length, 1);
        expect(
          profileProvider.certifications?[0].name,
          'Flutter Certification',
        );
        expect(profileProvider.isLoading, false);
        expect(profileProvider.certificationError, isNull);
      });

      test(
        'removeCertification should remove certification on success',
        () async {
          // Arrange
          profileProvider.certifications = [testCertification];
          when(
            mockDeleteCertificationUseCase.call(any),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await profileProvider.removeCertification(0);

          // Assert
          expect(profileProvider.certifications?.length, 0);
          expect(profileProvider.isLoading, false);
          expect(profileProvider.certificationError, isNull);
        },
      );

      test(
        'updateCertification should update certification on success',
        () async {
          // Arrange
          final oldCertification = testCertification;
          final newCertification = testCertification.copyWith(
            name: 'Advanced Flutter Certification',
          );
          profileProvider.certifications = [oldCertification];
          when(
            mockUpdateCertificationUseCase.call(any),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await profileProvider.updateCertification(
            oldCertification,
            newCertification,
          );

          // Assert
          expect(
            profileProvider.certifications?[0].name,
            'Advanced Flutter Certification',
          );
          expect(profileProvider.isLoading, false);
          expect(profileProvider.certificationError, isNull);
        },
      );
    });

    group('Skills', () {
      final testSkill = Skill(
        skillName: 'Flutter',
        endorsements: ['user1', 'user2', 'user3', 'user4', 'user5'],
      );

      test('addSkill should add skill on success', () async {
        // Arrange
        when(
          mockAddSkillUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.addSkill(testSkill);

        // Assert
        expect(profileProvider.skills?.length, 1);
        expect(profileProvider.skills?[0].skillName, 'Flutter');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.skillError, isNull);
      });

      test('removeSkill should remove skill on success', () async {
        // Arrange
        profileProvider.skills = [testSkill];
        when(
          mockDeleteSkillUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.removeSkill(0);

        // Assert
        expect(profileProvider.skills?.length, 0);
        expect(profileProvider.isLoading, false);
        expect(profileProvider.skillError, isNull);
      });

      test('updateSkill should update skill on success', () async {
        // Arrange
        profileProvider.skills = [testSkill];
        final updatedSkill = testSkill.copyWith(position: '2');
        when(
          mockUpdateSkillUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await profileProvider.updateSkill(0, updatedSkill);

        // Assert
        expect(profileProvider.skills?[0].position, '2');
        expect(profileProvider.isLoading, false);
        expect(profileProvider.skillError, isNull);
      });
    });

    group('Endorsements', () {
      final testEndorsements = [
        Endorsement(
          userId: 'user1', // Added required field
          firstName: 'Alice',
          lastName: 'Smith',
          profilePicture: 'alice.jpg',
        ),
        Endorsement(
          userId: 'user2', // Added required field
          firstName: 'Bob',
          lastName: 'Johnson',
          profilePicture: 'bob.jpg',
        ),
      ];

      test('getSkillEndorsements should update state on success', () async {
        // Arrange
        profileProvider.userId = 'test123';
        when(
          mockGetSkillEndorsementsUseCase.call(any),
        ).thenAnswer((_) async => Right(testEndorsements));

        // Act
        await profileProvider.getSkillEndorsements('Flutter');

        // Assert
        expect(profileProvider.currentEndorsements?.length, 2);
        expect(profileProvider.isLoadingEndorsements, false);
        expect(profileProvider.endorsementsError, isNull);
      });

      test('getSkillEndorsements should set error on failure', () async {
        // Arrange
        profileProvider.userId = 'test123';
        when(
          mockGetSkillEndorsementsUseCase.call(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // Act
        await profileProvider.getSkillEndorsements('Flutter');

        // Assert
        expect(profileProvider.currentEndorsements, isNull);
        expect(profileProvider.isLoadingEndorsements, false);
        expect(profileProvider.endorsementsError, isNotNull);
      });
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
          // Initial state
          expect(profileProvider.isExpandedExperiences, false);

          // First toggle
          profileProvider.toggleExperienceExpansion();
          expect(profileProvider.isExpandedExperiences, true);

          // Second toggle
          profileProvider.toggleExperienceExpansion();
          expect(profileProvider.isExpandedExperiences, false);
        },
      );

      test(
        'toggleEducationExpansion should toggle education expansion state',
        () {
          // Initial state
          expect(profileProvider.isExpandedEducation, false);

          // First toggle
          profileProvider.toggleEducationExpansion();
          expect(profileProvider.isExpandedEducation, true);

          // Second toggle
          profileProvider.toggleEducationExpansion();
          expect(profileProvider.isExpandedEducation, false);
        },
      );

      test(
        'toggleCertificationExpansion should toggle certifications expansion state',
        () {
          // Initial state
          expect(profileProvider.isExpandedCertifications, false);

          // First toggle
          profileProvider.toggleCertificationExpansion();
          expect(profileProvider.isExpandedCertifications, true);

          // Second toggle
          profileProvider.toggleCertificationExpansion();
          expect(profileProvider.isExpandedCertifications, false);
        },
      );

      test('toggleSkillsExpansion should toggle skills expansion state', () {
        // Initial state
        expect(profileProvider.isExpandedSkills, false);

        // First toggle
        profileProvider.toggleSkillsExpansion();
        expect(profileProvider.isExpandedSkills, true);

        // Second toggle
        profileProvider.toggleSkillsExpansion();
        expect(profileProvider.isExpandedSkills, false);
      });
    });

    group('Error Handling', () {
      test('clearErrors should clear all error states', () {
        // Set some errors
        profileProvider.profileError = 'Error';
        profileProvider.experienceError = 'Error';
        profileProvider.educationError = 'Error';
        profileProvider.skillError = 'Error';
        profileProvider.certificationError = 'Error';
        profileProvider.bioError = 'Error';
        profileProvider.resumeError = 'Error';
        profileProvider.endorsementsError = 'Error';

        // Clear errors
        profileProvider.clearErrors();

        // Verify all errors are null
        expect(profileProvider.profileError, isNull);
        expect(profileProvider.experienceError, isNull);
        expect(profileProvider.educationError, isNull);
        expect(profileProvider.skillError, isNull);
        expect(profileProvider.certificationError, isNull);
        expect(profileProvider.bioError, isNull);
        expect(profileProvider.resumeError, isNull);
        expect(profileProvider.endorsementsError, isNull);
      });

      test('clearEndorsementsError should clear only endorsements error', () {
        // Set some errors
        profileProvider.endorsementsError = 'Error';
        profileProvider.profileError = 'Other Error';

        // Clear endorsements error
        profileProvider.clearEndorsementsError();

        // Verify only endorsements error is cleared
        expect(profileProvider.endorsementsError, isNull);
        expect(profileProvider.profileError, 'Other Error');
      });

      test(
        '_mapFailureToMessage should return correct message for each failure type',
        () {
          expect(
            profileProvider._mapFailureToMessage(ServerFailure()),
            'Server error occurred. Please try again later.',
          );
          expect(
            profileProvider._mapFailureToMessage(NetworkFailure()),
            'Network error. Please check your connection.',
          );
          expect(
            profileProvider._mapFailureToMessage(CacheFailure()),
            'Cache error. Please restart the app.',
          );
          expect(
            profileProvider._mapFailureToMessage(ValidationFailure('Test')),
            'Validation error: Test',
          );
          expect(
            profileProvider._mapFailureToMessage(UnknownFailure()),
            'Unexpected error occurred. Please try again.',
          );
        },
      );
    });
  });
}
