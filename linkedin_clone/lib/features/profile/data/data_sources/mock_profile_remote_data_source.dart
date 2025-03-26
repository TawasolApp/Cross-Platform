import 'dart:async';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_data_source.dart';
import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';
import 'package:linkedin_clone/features/profile/data/models/endorsement_model.dart';

class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  // Mock profile data
  ProfileModel _profile = ProfileModel(
    userId: '123456',
    name: 'John Doe',
    headline: 'Senior Flutter Developer | Open Source Contributor',
    bio: 'Passionate about building cross-platform applications with Flutter. '
        'Specializing in state management and performance optimization.',
    location: 'San Francisco, CA',
    industry: 'Software Development',
    profilePicture: 'https://randomuser.me/api/portraits/men/42.jpg',
    coverPhoto: 'https://picsum.photos/1600/400',
    resume: 'https://example.com/johndoe-resume-2023.pdf',
    connectionCount: 872,
    visibility: 'public',

    // SKILLS (8 examples)
    skills: [
      // Technical Skills
      SkillModel(
        skill: 'Flutter',
        endorsements: [
          EndorsementModel(userId: 'user1', profilePicUrl: 'https://randomuser.me/api/portraits/women/12.jpg'),
          EndorsementModel(userId: 'user2', profilePicUrl: 'https://randomuser.me/api/portraits/men/24.jpg'),
          EndorsementModel(userId: 'user3', profilePicUrl: 'https://randomuser.me/api/portraits/women/33.jpg'),
        ],
      ),
      SkillModel(
        skill: 'Dart',
        endorsements: [
          EndorsementModel(userId: 'user4', profilePicUrl: 'https://randomuser.me/api/portraits/men/15.jpg'),
        ],
      ),
      
      // Programming Languages
      SkillModel(skill: 'Kotlin'),
      SkillModel(skill: 'Swift'),
      
      // Frameworks
      SkillModel(skill: 'Firebase'),
      SkillModel(skill: 'GraphQL'),
      
      // Design
      SkillModel(skill: 'UI/UX Design'),
      SkillModel(skill: 'Figma'),
      
      // DevOps
      SkillModel(skill: 'CI/CD Pipelines'),
    ],

    // EXPERIENCES (6 examples)
    experience: [
      // Current Position
      ExperienceModel(
        title: 'Senior Flutter Engineer',
        company: 'Tech Innovations Inc.',
        location: 'San Francisco, CA (Remote)',
        startDate: '2021-03',
        description: 'Lead the Flutter mobile team, architecting scalable solutions '
            'for 1M+ user applications. Implemented BLoC pattern across all projects.',
        employmentType: 'Full-time',
        locationType: 'Remote',
        companyPicUrl: 'https://logo.clearbit.com/techinnovations.com',
      ),
      
      // Previous Position
      ExperienceModel(
        title: 'Mobile Developer',
        company: 'Digital Solutions LLC',
        location: 'New York, NY',
        startDate: '2019-06',
        endDate: '2021-02',
        description: 'Developed hybrid mobile apps using Flutter. Reduced crash rate by 42%.',
        employmentType: 'Full-time',
        locationType: 'Hybrid',
      ),
      
      // Internship
      ExperienceModel(
        title: 'Software Engineering Intern',
        company: 'StartUp Labs',
        location: 'Boston, MA',
        startDate: '2018-05',
        endDate: '2018-08',
        description: 'Learned agile development practices. Contributed to open source projects.',
        employmentType: 'Internship',
        locationType: 'On-site',
      ),
      
      // Freelance
      ExperienceModel(
        title: 'Freelance Mobile Developer',
        company: 'Self-Employed',
        location: 'Remote',
        startDate: '2017-01',
        endDate: '2019-05',
        description: 'Built custom mobile solutions for small businesses and startups.',
        employmentType: 'Contract',
        locationType: 'Remote',
      ),
      
      // Early Career
      ExperienceModel(
        title: 'Junior Developer',
        company: 'WebTech Solutions',
        location: 'Chicago, IL',
        startDate: '2016-01',
        endDate: '2017-12',
        description: 'First professional developer role. Learned fundamentals of mobile development.',
        employmentType: 'Full-time',
        locationType: 'On-site',
      ),
      
      // Side Project
      ExperienceModel(
        title: 'Open Source Contributor',
        company: 'GitHub',
        location: 'Remote',
        startDate: '2018-01',
        description: 'Contributed to popular Flutter packages like flutter_bloc and dio.',
        employmentType: 'Part-time',
        locationType: 'Remote',
      ),
    ],

    // EDUCATION (5 examples)
    education: [
      // University Degree
      EducationModel(
        school: 'Massachusetts Institute of Technology',
        schoolPic: 'https://logo.clearbit.com/mit.edu',
        degree: 'Master of Computer Science',
        field: 'Software Engineering',
        startDate: '2014-09',
        endDate: '2016-05',
        grade: '3.9 GPA',
        description: 'Specialized in mobile development and distributed systems. '
            'Thesis on "Cross-Platform Performance Optimization"',
      ),
      
      // Bachelor's Degree
      EducationModel(
        school: 'Stanford University',
        schoolPic: 'https://logo.clearbit.com/stanford.edu',
        degree: 'Bachelor of Science',
        field: 'Computer Science',
        startDate: '2010-09',
        endDate: '2014-05',
        grade: '3.7 GPA',
        description: 'Minor in Mathematics. President of CS Club.',
      ),
      
      // Online Course
      EducationModel(
        school: 'Coursera',
        degree: 'Advanced Flutter Development',
        field: 'Mobile Development',
        startDate: '2020-03',
        endDate: '2020-06',
        description: 'Specialization certificate from Google',
        grade: 'A+',
      ),
      
      // Bootcamp
      EducationModel(
        school: 'App Brewery',
        degree: 'Mobile Development Bootcamp',
        field: 'Flutter',
        startDate: '2019-01',
        endDate: '2019-03',
        description: 'Intensive 12-week program',
        grade: 'A',
      ),
      
      // High School
      EducationModel(
        school: 'Boston Latin School',
        degree: 'High School Diploma',
        field: 'General Studies',
        startDate: '2006-09',
        endDate: '2010-05',
        grade: '4.0 GPA',
        description: 'Valedictorian. National Merit Scholar.',
      ),
    ],

    // CERTIFICATIONS (6 examples)
    certifications: [
      // Technical Certifications
      CertificationModel(
        name: 'Flutter Certified Developer',
        issuingOrganization: 'Google',
        issuingOrganizationPic: 'https://logo.clearbit.com/google.com',
        issueDate: '2022-01',
        expirationDate: '2024-01',
      ),
      
      CertificationModel(
        name: 'AWS Certified Developer - Associate',
        issuingOrganization: 'Amazon Web Services',
        issuingOrganizationPic: 'https://logo.clearbit.com/aws.amazon.com',
        issueDate: '2021-06',
        expirationDate: '2024-06',
      ),
      
      // Programming Certifications
      CertificationModel(
        name: 'Dart Programming Expert',
        issuingOrganization: 'Dart Language',
        issueDate: '2020-09',
      ),
      
      // Project Management
      CertificationModel(
        name: 'Agile Certified Practitioner',
        issuingOrganization: 'PMI',
        issuingOrganizationPic: 'https://logo.clearbit.com/pmi.org',
        issueDate: '2019-03',
        expirationDate: '2025-03',
      ),
      
      // Design
      CertificationModel(
        name: 'UI/UX Design Specialization',
        issuingOrganization: 'Coursera',
        issueDate: '2018-11',
      ),
      
      // Language
      CertificationModel(
        name: 'Professional English Certification',
        issuingOrganization: 'Cambridge University',
        issueDate: '2015-05',
      ),
    ],
  );

  // Simulate network delay
  Future<void> _delay() {
    return Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<ProfileModel> getProfile() async {
    await _delay();
    return _profile;
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    await _delay();
    _profile = profile;
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? profilePictureUrl,
    String? coverPhoto,
    String? resume,
    String? headline,
    String? bio,
    String? location,
    String? industry,
  }) async {
    await _delay();
    
    _profile = _profile.copyWith(
      name: name,
      profilePicture: profilePictureUrl,
      coverPhoto: coverPhoto,
      resume: resume,
      headline: headline,
      bio: bio,
      location: location,
      industry: industry,
    );
  }

  @override
  Future<void> deleteProfilePicture() async {
    await _delay();
    _profile = _profile.copyWith(
      profilePicture: null,
    );
  }

  @override
  Future<void> deleteCoverPhoto() async {
    await _delay();
    _profile = _profile.copyWith(
      coverPhoto: null,
    );
  }

  @override
  Future<void> addExperience(ExperienceModel experience) async {
    await _delay();
    final newExperiences = List<ExperienceModel>.from(_profile.experience)..add(experience);
    _profile = _profile.copyWith(experience: newExperiences);
  }

  @override
  Future<void> updateExperience(ExperienceModel experience) async {
    await _delay();
    final updatedExperiences = _profile.experience.map((e) {
      final exp = e;
      return (exp.title == experience.title && exp.company == experience.company) 
          ? experience 
          : exp;
    }).toList();
    _profile = _profile.copyWith(experience: updatedExperiences);
  }

  @override
  Future<void> deleteExperience(String experienceId) async {
    await _delay();
    final filteredExperiences = _profile.experience
        .where((exp) => (exp).title != experienceId)
        .map((e) => e)
        .toList();
    _profile = _profile.copyWith(experience: filteredExperiences);
  }

  @override
  Future<void> addEducation(EducationModel education) async {
    await _delay();
    final newEducation = List<EducationModel>.from(_profile.education)..add(education);
    _profile = _profile.copyWith(education: newEducation);
  }

  @override
  Future<void> updateEducation(EducationModel education) async {
    await _delay();
    final updatedEducation = _profile.education.map((e) {
      final edu = e;
      return (edu.school == education.school && edu.degree == education.degree) 
          ? education 
          : edu;
    }).toList();
    _profile = _profile.copyWith(education: updatedEducation);
  }

  @override
  Future<void> deleteEducation(String educationId) async {
    await _delay();
    final filteredEducation = _profile.education
        .where((edu) => (edu).school != educationId)
        .map((e) => e)
        .toList();
    _profile = _profile.copyWith(education: filteredEducation);
  }

  @override
  Future<void> addSkill(SkillModel skill) async {
    await _delay();
    final newSkills = List<SkillModel>.from(_profile.skills)..add(skill);
    _profile = _profile.copyWith(skills: newSkills);
  }

  @override
  Future<void> updateSkill(SkillModel skill) async {
    await _delay();
    final updatedSkills = _profile.skills.map((s) {
      final skillModel = s;
      return skillModel.skill == skill.skill ? skill : skillModel;
    }).toList();
    _profile = _profile.copyWith(skills: updatedSkills);
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    await _delay();
    final filteredSkills = _profile.skills
        .where((skill) => (skill).skill != skillId)
        .map((s) => s)
        .toList();
    _profile = _profile.copyWith(skills: filteredSkills);
  }

  @override
  Future<void> addCertification(CertificationModel certification) async {
    await _delay();
    final newCertifications = List<CertificationModel>.from(_profile.certifications)..add(certification);
    _profile = _profile.copyWith(certifications: newCertifications);
  }

  @override
  Future<void> updateCertification(CertificationModel certification) async {
    await _delay();
    final updatedCertifications = _profile.certifications.map((c) {
      final cert = c;
      return (cert.name == certification.name && 
              cert.issuingOrganization == certification.issuingOrganization) 
          ? certification 
          : cert;
    }).toList();
    _profile = _profile.copyWith(certifications: updatedCertifications);
  }

  @override
  Future<void> deleteCertification(String certificationId) async {
    await _delay();
    final filteredCertifications = _profile.certifications
        .where((cert) => (cert).name != certificationId)
        .map((c) => c)
        .toList();
    _profile = _profile.copyWith(certifications: filteredCertifications);
  }

  // Test helper methods
  void resetMockProfile() {
    _profile = ProfileModel(
      userId: '123456',
      name: 'John Doe',
      skills: [],
      education: [],
      certifications: [],
      experience: [],
    );
  }
}