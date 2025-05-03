// import 'dart:async';
// import 'package:linkedin_clone/features/profile/data/data_sources/profile_data_source.dart';
// import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/endorsement_model.dart';

// class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
//   // Mock profile data
//   ProfileModel _profile = ProfileModel(
//     userId: '123456',
//     firstName: 'John',
//     lastName: 'Doe',
//     headline: 'Senior Flutter Developer | Open Source Contributor',
//     bio:
//         'Passionate about building cross-platform applications with Flutter. '
//         'Specializing in state management and performance optimization.',
//     location: 'San Francisco, CA',
//     industry: 'Software Development',
//     profilePicture: 'https://randomuser.me/api/portraits/men/42.jpg',
//     coverPhoto: 'https://picsum.photos/1600/400',
//     resume:
//         'https://drive.google.com/file/d/1qqh0yXoTne-9VtHyedWDIgt2onJkrVm8/view',
//     connectionCount: 872,
//     visibility: 'public',

//     // SKILLS (8 examples)
//     skills: [
//       // Technical Skills
//       SkillModel(
//         skillName: 'Flutter',
//         endorsements: [
//           EndorsementModel(
//             userId: 'user1',
//             profilePicUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
//           ),
//           EndorsementModel(
//             userId: 'user2',
//             profilePicUrl: 'https://randomuser.me/api/portraits/men/24.jpg',
//           ),
//           EndorsementModel(
//             userId: 'user3',
//             profilePicUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
//           ),
//         ],
//       ),
//       SkillModel(
//         skillName: 'Dart',
//         endorsements: [
//           EndorsementModel(
//             userId: 'user4',
//             profilePicUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
//           ),
//         ],
//       ),

//       // Programming Languages
//       SkillModel(skillName: 'Kotlin'),
//       SkillModel(skillName: 'Swift'),

//       // Frameworks
//       SkillModel(skillName: 'Firebase'),
//       SkillModel(skillName: 'GraphQL'),

//       // Design
//       SkillModel(skillName: 'UI/UX Design'),
//       SkillModel(skillName: 'Figma'),

//       // DevOps
//       SkillModel(skillName: 'CI/CD Pipelines'),
//     ],

//     // EXPERIENCES (6 examples)
//     workExperience: [
//       // Current Position
//       ExperienceModel(
//         title: 'Senior Flutter Engineer',
//         company: 'Tech Innovations Inc.',
//         location: 'San Francisco, CA (Remote)',
//         startDate: '2021-03',
//         description:
//             'Lead the Flutter mobile team, architecting scalable solutions '
//             'for 1M+ user applications. Implemented BLoC pattern across all projects.',
//         employmentType: 'Full-time',
//         locationType: 'Remote',
//         companyPicUrl: 'https://logo.clearbit.com/techinnovations.com',
//       ),

//       // Previous Position
//       ExperienceModel(
//         title: 'Mobile Developer',
//         company: 'Digital Solutions LLC',
//         location: 'New York, NY',
//         startDate: '2019-06',
//         endDate: '2021-02',
//         description:
//             'Developed hybrid mobile apps using Flutter. Reduced crash rate by 42%.',
//         employmentType: 'Full-time',
//         locationType: 'Hybrid',
//       ),

//       // Internship
//       ExperienceModel(
//         title: 'Software Engineering Intern',
//         company: 'StartUp Labs',
//         location: 'Boston, MA',
//         startDate: '2018-05',
//         endDate: '2018-08',
//         description:
//             'Learned agile development practices. Contributed to open source projects.',
//         employmentType: 'Internship',
//         locationType: 'On-site',
//       ),

//       // Freelance
//       ExperienceModel(
//         title: 'Freelance Mobile Developer',
//         company: 'Self-Employed',
//         location: 'Remote',
//         startDate: '2017-01',
//         endDate: '2019-05',
//         description:
//             'Built custom mobile solutions for small businesses and startups.',
//         employmentType: 'Contract',
//         locationType: 'Remote',
//       ),

//       // Early Career
//       ExperienceModel(
//         title: 'Junior Developer',
//         company: 'WebTech Solutions',
//         location: 'Chicago, IL',
//         startDate: '2016-01',
//         endDate: '2017-12',
//         description:
//             'First professional developer role. Learned fundamentals of mobile development.',
//         employmentType: 'Full-time',
//         locationType: 'On-site',
//       ),

//       // Side Project
//       ExperienceModel(
//         title: 'Open Source Contributor',
//         company: 'GitHub',
//         location: 'Remote',
//         startDate: '2018-01',
//         description:
//             'Contributed to popular Flutter packages like flutter_bloc and dio.',
//         employmentType: 'Part-time',
//         locationType: 'Remote',
//       ),
//     ],

//     // EDUCATION (5 examples)
//     education: [
//       // University Degree
//       EducationModel(
//         school: 'Massachusetts Institute of Technology',
//         schoolPic: 'https://logo.clearbit.com/mit.edu',
//         degree: 'Master of Computer Science',
//         field: 'Software Engineering',
//         startDate: '2014-09',
//         endDate: '2016-05',
//         grade: '3.9 GPA',
//         description:
//             'Specialized in mobile development and distributed systems. '
//             'Thesis on "Cross-Platform Performance Optimization"',
//       ),

//       // Bachelor's Degree
//       EducationModel(
//         school: 'Stanford University',
//         schoolPic: 'https://logo.clearbit.com/stanford.edu',
//         degree: 'Bachelor of Science',
//         field: 'Computer Science',
//         startDate: '2010-09',
//         endDate: '2014-05',
//         grade: '3.7 GPA',
//         description: 'Minor in Mathematics. President of CS Club.',
//       ),

//       // Online Course
//       EducationModel(
//         school: 'Coursera',
//         degree: 'Advanced Flutter Development',
//         field: 'Mobile Development',
//         startDate: '2020-03',
//         endDate: '2020-06',
//         description: 'Specialization certificate from Google',
//         grade: 'A+',
//       ),

//       // Bootcamp
//       EducationModel(
//         school: 'App Brewery',
//         degree: 'Mobile Development Bootcamp',
//         field: 'Flutter',
//         startDate: '2019-01',
//         endDate: '2019-03',
//         description: 'Intensive 12-week program',
//         grade: 'A',
//       ),

//       // High School
//       EducationModel(
//         school: 'Boston Latin School',
//         degree: 'High School Diploma',
//         field: 'General Studies',
//         startDate: '2006-09',
//         endDate: '2010-05',
//         grade: '4.0 GPA',
//         description: 'Valedictorian. National Merit Scholar.',
//       ),
//     ],

//     // CERTIFICATIONS (6 examples)
//     certification: [
//       // Technical Certifications
//       CertificationModel(
//         name: 'Flutter Certified Developer',
//         company: 'Google',
//         companyPic: 'https://logo.clearbit.com/google.com',
//         issueDate: '2022-01',
//         expirationDate: '2024-01',
//       ),

//       CertificationModel(
//         name: 'AWS Certified Developer - Associate',
//         company: 'Amazon Web Services',
//         companyPic: 'https://logo.clearbit.com/aws.amazon.com',
//         issueDate: '2021-06',
//         expirationDate: '2024-06',
//       ),

//       // Programming Certifications
//       CertificationModel(
//         name: 'Dart Programming Expert',
//         company: 'Dart Language',
//         issueDate: '2020-09',
//       ),

//       // Project Management
//       CertificationModel(
//         name: 'Agile Certified Practitioner',
//         company: 'PMI',
//         companyPic: 'https://logo.clearbit.com/pmi.org',
//         issueDate: '2019-03',
//         expirationDate: '2025-03',
//       ),

//       // Design
//       CertificationModel(
//         name: 'UI/UX Design Specialization',
//         company: 'Coursera',
//         issueDate: '2018-11',
//       ),

//       // Language
//       CertificationModel(
//         name: 'Professional English Certification',
//         company: 'Cambridge University',
//         issueDate: '2015-05',
//       ),
//     ],
//   );

//   // Simulate network delay
//   Future<void> _delay() {
//     return Future.delayed(const Duration(milliseconds: 800));
//   }

//   @override
//   Future<ProfileModel> getProfile(String id) async {
//     await _delay();
//     return _profile;
//   }

//   @override
//   Future<void> createProfile(ProfileModel profile) async {
//     await _delay();
//     _profile = profile;
//   }

//   @override
//   Future<void> updateProfile(ProfileModel profile) async {
//     await _delay();
//     _profile = profile;
//   }

//   @override
//   Future<void> deleteProfilePicture() async {
//     await _delay();
//     _profile = _profile.copyWith(profilePicture: null);
//   }

//   @override
//   Future<void> deleteCoverPhoto() async {
//     await _delay();
//     _profile = _profile.copyWith(coverPhoto: null);
//   }

//   @override
//   Future<void> deleteResume() async {
//     await _delay();
//     _profile = _profile.copyWith(resume: null);
//   }

//   @override
//   Future<void> deleteHeadline() async {
//     await _delay();
//     _profile = _profile.copyWith(headline: null);
//   }

//   @override
//   Future<void> deleteBio() async {
//     await _delay();
//     _profile = _profile.copyWith(bio: null);
//   }

//   @override
//   Future<void> deleteLocation() async {
//     await _delay();
//     _profile = _profile.copyWith(location: null);
//   }

//   @override
//   Future<void> deleteIndustry() async {
//     await _delay();
//     _profile = _profile.copyWith(industry: null);
//   }

//   @override
//   Future<void> addWorkExperience(ExperienceModel experience) async {
//     await _delay();
//     final newExperiences = List<ExperienceModel>.from(_profile.workExperience)
//       ..add(experience);
//     _profile = _profile.copyWith(workExperience: newExperiences);
//   }

//   @override
//   Future<void> updateWorkExperience(
//     String workExperienceId,
//     ExperienceModel experience,
//   ) async {
//     await _delay();
//     final updatedExperiences =
//         _profile.workExperience.map((e) {
//           // Use some identifier logic that matches your workExperienceId
//           return e.title == workExperienceId ? experience : e;
//         }).toList();
//     _profile = _profile.copyWith(workExperience: updatedExperiences);
//   }

//   @override
//   Future<void> deleteWorkExperience(String workExperienceId) async {
//     await _delay();
//     final filteredExperiences =
//         _profile.workExperience
//             .where((exp) => exp.title != workExperienceId)
//             .toList();
//     _profile = _profile.copyWith(workExperience: filteredExperiences);
//   }

//   @override
//   Future<void> addEducation(EducationModel education) async {
//     await _delay();
//     final newEducation = List<EducationModel>.from(_profile.education)
//       ..add(education);
//     _profile = _profile.copyWith(education: newEducation);
//   }

//   @override
//   Future<void> updateEducation(
//     String educationId,
//     EducationModel education,
//   ) async {
//     await _delay();
//     final updatedEducation =
//         _profile.education.map((e) {
//           // Use some identifier logic that matches your educationId
//           return e.school == educationId ? education : e;
//         }).toList();
//     _profile = _profile.copyWith(education: updatedEducation);
//   }

//   @override
//   Future<void> deleteEducation(String educationId) async {
//     await _delay();
//     final filteredEducation =
//         _profile.education.where((edu) => edu.school != educationId).toList();
//     _profile = _profile.copyWith(education: filteredEducation);
//   }

//   @override
//   Future<void> addSkill(SkillModel skill) async {
//     await _delay();
//     final newSkills = List<SkillModel>.from(_profile.skills)..add(skill);
//     _profile = _profile.copyWith(skills: newSkills);
//   }

//   @override
//   Future<void> deleteSkill(String skillName) async {
//     await _delay();
//     final filteredSkills =
//         _profile.skills.where((skill) => skill.skillName != skillName).toList();
//     _profile = _profile.copyWith(skills: filteredSkills);
//   }

//   @override
//   Future<void> addCertification(CertificationModel certification) async {
//     await _delay();
//     final newCertifications = List<CertificationModel>.from(
//       _profile.certification,
//     )..add(certification);
//     _profile = _profile.copyWith(certification: newCertifications);
//   }

//   @override
//   Future<void> updateCertification(
//     String certificationId,
//     CertificationModel certification,
//   ) async {
//     await _delay();
//     final updatedCertifications =
//         _profile.certification.map((c) {
//           // Use some identifier logic that matches your certificationId
//           return c.name == certificationId ? certification : c;
//         }).toList();
//     _profile = _profile.copyWith(certification: updatedCertifications);
//   }

//   @override
//   Future<void> deleteCertification(String certificationId) async {
//     await _delay();
//     final filteredCertifications =
//         _profile.certification
//             .where((cert) => cert.name != certificationId)
//             .toList();
//     _profile = _profile.copyWith(certification: filteredCertifications);
//   }

//   @override
//   Future<List<dynamic>> getFollowedCompanies(String userId) async {
//     await _delay();
//     // Mock data for followed companies
//     return [
//       {
//         'id': '1',
//         'name': 'Google',
//         'logo': 'https://logo.clearbit.com/google.com',
//       },
//       {
//         'id': '2',
//         'name': 'Microsoft',
//         'logo': 'https://logo.clearbit.com/microsoft.com',
//       },
//       {
//         'id': '3',
//         'name': 'Apple',
//         'logo': 'https://logo.clearbit.com/apple.com',
//       },
//     ];
//   }

//   @override
//   Future<List<dynamic>> getPosts(String userId) async {
//     await _delay();
//     // Mock data for user posts
//     return [
//       {
//         'id': '1',
//         'content': 'Just launched a new Flutter project!',
//         'likes': 42,
//       },
//       {
//         'id': '2',
//         'content': 'Thoughts on the latest Dart features?',
//         'likes': 27,
//       },
//       {
//         'id': '3',
//         'content': 'Looking for Flutter developers to join our team.',
//         'likes': 68,
//       },
//     ];
//   }

//   // Test helper methods
//   void resetMockProfile() {
//     _profile = ProfileModel(
//       userId: '123456',
//       firstName: 'John',
//       lastName: 'Doe',
//       skills: [],
//       education: [],
//       certification: [],
//       workExperience: [],
//     );
//   }
// }
