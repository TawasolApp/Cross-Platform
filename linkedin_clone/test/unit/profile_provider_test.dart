import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';

// Mock classes for all use cases
class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockAddExperienceUseCase extends Mock implements AddExperienceUseCase {}
class MockUpdateExperienceUseCase extends Mock implements UpdateExperienceUseCase {}
class MockDeleteExperienceUseCase extends Mock implements DeleteExperienceUseCase {}
class MockAddSkillUseCase extends Mock implements AddSkillUseCase {}
class MockUpdateSkillUseCase extends Mock implements UpdateSkillUseCase {}
class MockDeleteSkillUseCase extends Mock implements DeleteSkillUseCase {}
class MockAddEducationUseCase extends Mock implements AddEducationUseCase {}
class MockUpdateEducationUseCase extends Mock implements UpdateEducationUseCase {}
class MockDeleteEducationUseCase extends Mock implements DeleteEducationUseCase {}
class MockAddCertificationUseCase extends Mock implements AddCertificationUseCase {}
class MockUpdateCertificationUseCase extends Mock implements UpdateCertificationUseCase {}
class MockDeleteCertificationUseCase extends Mock implements DeleteCertificationUseCase {}
class MockUpdateBioUseCase extends Mock implements UpdateBioUseCase {}
class MockNoParams extends Mock implements NoParams {}

// Test data
const testExperience = Experience(
  title: 'Flutter Developer',
  company: 'Tech Co',
  location: 'Remote',
  startDate: '01/2020',
  endDate: '12/2022',
  description: 'Developed apps',
  employmentType: 'Full-time',
  locationType: 'Remote',
);

const testEducation = Education(
  school: 'University',
  degree: 'Bachelor',
  field: 'Computer Science',
  startDate: '08/2018',
  endDate: '06/2022',
  description: 'Studied CS',
  grade: '3.7',
);

const testSkill = Skill(
  skill: 'Flutter',
  endorsements: [],
);

const testCertification = Certification(
  name: 'Flutter Certified',
  issuingOrganization: 'Google',
  issueDate: '03/2023',
);

// Mock profile data for testing
final mockProfile = Profile(
  userId: 'user123',
  name: 'Test User',
  profilePicture: 'profile.jpg',
  coverPhoto: 'cover.jpg',
  resume: 'resume.pdf',
  headline: 'Flutter Developer',
  bio: 'Experienced developer',
  location: 'New York',
  industry: 'Technology',
  skills: [testSkill],
  education: [testEducation],
  certifications: [testCertification],
  experience: [testExperience],
  visibility: 'public',
  connectionCount: 500,
);

void main() {
  late ProfileProvider provider;
  late MockGetProfileUseCase mockGetProfile;
  late MockAddExperienceUseCase mockAddExperience;
  late MockUpdateExperienceUseCase mockUpdateExperience;
  late MockDeleteExperienceUseCase mockDeleteExperience;
  late MockAddSkillUseCase mockAddSkill;
  late MockUpdateSkillUseCase mockUpdateSkill;
  late MockDeleteSkillUseCase mockDeleteSkill;
  late MockAddEducationUseCase mockAddEducation;
  late MockUpdateEducationUseCase mockUpdateEducation;
  late MockDeleteEducationUseCase mockDeleteEducation;
  late MockAddCertificationUseCase mockAddCertification;
  late MockUpdateCertificationUseCase mockUpdateCertification;
  late MockDeleteCertificationUseCase mockDeleteCertification;
  late MockUpdateBioUseCase mockUpdateBio;

  setUpAll(() {
    registerFallbackValue(MockNoParams());
  });

  setUp(() {
    mockGetProfile = MockGetProfileUseCase();
    mockAddExperience = MockAddExperienceUseCase();
    mockUpdateExperience = MockUpdateExperienceUseCase();
    mockDeleteExperience = MockDeleteExperienceUseCase();
    mockAddSkill = MockAddSkillUseCase();
    mockUpdateSkill = MockUpdateSkillUseCase();
    mockDeleteSkill = MockDeleteSkillUseCase();
    mockAddEducation = MockAddEducationUseCase();
    mockUpdateEducation = MockUpdateEducationUseCase();
    mockDeleteEducation = MockDeleteEducationUseCase();
    mockAddCertification = MockAddCertificationUseCase();
    mockUpdateCertification = MockUpdateCertificationUseCase();
    mockDeleteCertification = MockDeleteCertificationUseCase();
    mockUpdateBio = MockUpdateBioUseCase();

    provider = ProfileProvider(
      mockGetProfile,
      mockAddExperience,
      mockUpdateExperience,
      mockDeleteExperience,
      mockAddEducation,
      mockUpdateEducation,
      mockDeleteEducation,
      mockAddCertification,
      mockUpdateCertification,
      mockDeleteCertification,
      mockAddSkill,
      mockUpdateSkill,
      mockDeleteSkill,
      mockUpdateBio,
    );
  });

  group('ProfileProvider', () {
    test('should update state when profile is fetched successfully', () async {
      // Arrange
      when(() => mockGetProfile(any()))
        .thenAnswer((_) => Future.value(Right(mockProfile)));
      
      // Act
      await provider.fetchProfile();
      
      // Assert
      expect(provider.name, mockProfile.name);
      expect(provider.bio, mockProfile.bio);
      expect(provider.experiences, mockProfile.experience);
      expect(provider.isLoading, false);
      expect(provider.profileError, isNull);
      verify(() => mockGetProfile(any())).called(1);
    });

    test('should set error when profile fetch fails', () async {
      // Arrange
      when(() => mockGetProfile(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      
      // Act
      await provider.fetchProfile();
      
      // Assert
      expect(provider.profileError, isNotNull);
      expect(provider.isLoading, false);
      verify(() => mockGetProfile(any())).called(1);
    });

    group('Experience', () {
      test('addExperience should add to state and call use case', () async {
        // Arrange
        when(() => mockAddExperience(testExperience))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.addExperience(testExperience);
        
        // Assert
        expect(provider.experiences, contains(testExperience));
        expect(provider.isLoading, false);
        verify(() => mockAddExperience(testExperience)).called(1);
      });

      test('updateExperience should update state and call use case', () async {
        // Arrange
        provider.experiences = [testExperience];
        final updatedExp = testExperience.copyWith(title: 'Senior Flutter Dev');
        when(() => mockUpdateExperience(updatedExp))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.updateExperience(testExperience, updatedExp);
        
        // Assert
        expect(provider.experiences, contains(updatedExp));
        expect(provider.experiences, isNot(contains(testExperience)));
        expect(provider.isLoading, false);
        verify(() => mockUpdateExperience(updatedExp)).called(1);
      });

      test('removeExperience should remove from state and call use case', () async {
        // Arrange
        provider.experiences = [testExperience];
        when(() => mockDeleteExperience(testExperience.company))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.removeExperience(0);
        
        // Assert
        expect(provider.experiences, isEmpty);
        expect(provider.isLoading, false);
        verify(() => mockDeleteExperience(testExperience.company)).called(1);
      });

       
    });

    group('Education', () {
      test('addEducation should add to state and call use case', () async {
        // Arrange
        when(() => mockAddEducation(testEducation))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.addEducation(testEducation);
        
        // Assert
        expect(provider.educations, contains(testEducation));
        expect(provider.isLoading, false);
        verify(() => mockAddEducation(testEducation)).called(1);
      });

      test('updateEducation should update state and call use case', () async {
        // Arrange
        provider.educations = [testEducation];
        final updatedEdu = testEducation.copyWith(degree: 'Master');
        when(() => mockUpdateEducation(updatedEdu))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.updateEducation(testEducation, updatedEdu);
        
        // Assert
        expect(provider.educations, contains(updatedEdu));
        expect(provider.educations, isNot(contains(testEducation)));
        expect(provider.isLoading, false);
        verify(() => mockUpdateEducation(updatedEdu)).called(1);
      });

      test('removeEducation should remove from state and call use case', () async {
        // Arrange
        provider.educations = [testEducation];
        when(() => mockDeleteEducation(testEducation.school))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.removeEducation(0);
        
        // Assert
        expect(provider.educations, isEmpty);
        expect(provider.isLoading, false);
        verify(() => mockDeleteEducation(testEducation.school)).called(1);
      });

       
    });

    group('Skills', () {
      test('addSkill should add to state and call use case', () async {
        // Arrange
        when(() => mockAddSkill(testSkill))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.addSkill(testSkill);
        
        // Assert
        expect(provider.skills, contains(testSkill));
        expect(provider.isLoading, false);
        verify(() => mockAddSkill(testSkill)).called(1);
      });

      test('updateSkill should update state and call use case', () async {
        // Arrange
        provider.skills = [testSkill];
        final updatedSkill = testSkill.copyWith(skill: 'Dart');
        when(() => mockUpdateSkill(updatedSkill))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.updateSkill(testSkill, updatedSkill);
        
        // Assert
        expect(provider.skills, contains(updatedSkill));
        expect(provider.skills, isNot(contains(testSkill)));
        expect(provider.isLoading, false);
        verify(() => mockUpdateSkill(updatedSkill)).called(1);
      });

      test('removeSkill should remove from state and call use case', () async {
        // Arrange
        provider.skills = [testSkill];
        when(() => mockDeleteSkill(testSkill.skill))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.removeSkill(0);
        
        // Assert
        expect(provider.skills, isEmpty);
        expect(provider.isLoading, false);
        verify(() => mockDeleteSkill(testSkill.skill)).called(1);
      });

       
    });

    group('Certifications', () {
      test('addCertification should add to state and call use case', () async {
        // Arrange
        when(() => mockAddCertification(testCertification))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.addCertification(testCertification);
        
        // Assert
        expect(provider.certifications, contains(testCertification));
        verify(() => mockAddCertification(testCertification)).called(1);
      });

      test('updateCertification should update state and call use case', () async {
        // Arrange
        provider.certifications = [testCertification];
        final updatedCert = testCertification.copyWith(name: 'Advanced Flutter');
        when(() => mockUpdateCertification(updatedCert))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.updateCertification(testCertification, updatedCert);
        
        // Assert
        expect(provider.certifications, contains(updatedCert));
        expect(provider.certifications, isNot(contains(testCertification)));
        expect(provider.isLoading, false);
        verify(() => mockUpdateCertification(updatedCert)).called(1);
      });

      test('removeCertification should remove from state and call use case', () async {
        // Arrange
        provider.certifications = [testCertification];
        when(() => mockDeleteCertification(testCertification.name))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.removeCertification(0);
        
        // Assert
        expect(provider.certifications, isEmpty);
        verify(() => mockDeleteCertification(testCertification.name)).called(1);
      });

     
    });

    group('Bio', () {
      test('setUserBio should update state and call use case', () async {
        // Arrange
        const newBio = 'Updated bio text';
        when(() => mockUpdateBio(newBio))
            .thenAnswer((_) async => Right(null));
        
        // Act
        await provider.setUserBio(newBio);
        
        // Assert
        expect(provider.bio, newBio);
        expect(provider.isLoading, false);
        verify(() => mockUpdateBio(newBio)).called(1);
      });

      test('should handle error when updating bio fails', () async {
        // Arrange
        const newBio = 'Updated bio text';
        when(() => mockUpdateBio(newBio))
            .thenAnswer((_) async => Left(ServerFailure()));
        
        // Act
        await provider.setUserBio(newBio);
        
        // Assert
        expect(provider.bioError, isNotNull);
      });
    });

    group('Toggle Methods', () {
      test('toggleExperienceExpansion should switch expansion state', () {
        // Initial state
        expect(provider.isExpandedExperiences, false);
        
        // Act
        provider.toggleExperienceExpansion();
        
        // Assert
        expect(provider.isExpandedExperiences, true);
        
        // Act again
        provider.toggleExperienceExpansion();
        
        // Assert again
        expect(provider.isExpandedExperiences, false);
      });

      test('toggleEducationExpansion should update education expansion state', () {
        // Initial state
        expect(provider.isExpandedEducation, false);
        
        // Act
        provider.toggleEducationExpansion();
        
        // Assert
        expect(provider.isExpandedEducation, true);
        
        // Act again
        provider.toggleEducationExpansion();
        
        // Assert again
        expect(provider.isExpandedEducation, false);
      });

      test('toggleSkillsExpansion should update skills expansion state', () {
        // Initial state
        expect(provider.isExpandedSkills, false);
        
        // Act
        provider.toggleSkillsExpansion();
        
        // Assert
        expect(provider.isExpandedSkills, true);
        
        // Act again
        provider.toggleSkillsExpansion();
        
        // Assert again
        expect(provider.isExpandedSkills, false);
      });

      test('toggleCertificationExpansion should update certification expansion state', () {
        // Initial state
        expect(provider.isExpandedCertifications, false);
        
        // Act
        provider.toggleCertificationExpansion();
        
        // Assert
        expect(provider.isExpandedCertifications, true);
        
        // Act again
        provider.toggleCertificationExpansion();
        
        // Assert again
        expect(provider.isExpandedCertifications, false);
      });
    });

    group('Loading State', () {
      test('should set loading state correctly', () {
        // Initial state
        expect(provider.isLoading, false);
        
        // Act
        provider.isLoading = true;
        
        // Assert
        expect(provider.isLoading, true);
        
        // Act again
        provider.isLoading = false;
        
        // Assert again
        expect(provider.isLoading, false);
      });
    });

    group('Error Handling', () {
      

      test('should set bio error correctly', () {
        // Arrange
        const errorMessage = 'Test error';
        
        // Act
        provider.bioError = errorMessage;
        
        // Assert
        expect(provider.bioError, errorMessage);
      });
    });
  });
}