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
//     name: 'John Doe',
//     headline: 'Software Engineer | Mobile Developer | Flutter Enthusiast',
//     bio: 'Passionate about building user-friendly mobile applications with Flutter. '
//         'I love solving complex problems and learning new technologies.',
//     location: 'New York, NY',
//     industry: 'Software Development',
//     profilePicture: 'https://randomuser.me/api/portraits/men/1.jpg',
//     coverPhoto: 'https://picsum.photos/800/200',
//     resume: 'https://example.com/johndoe-resume.pdf',
//     connectionCount: 500,
//     skills: [
//       SkillModel(
//         skill: 'Flutter',
//         endorsements: [
//           EndorsementModel(userId: 'user1', profilePicUrl: 'https://randomuser.me/api/portraits/women/1.jpg'),
//           EndorsementModel(userId: 'user2', profilePicUrl: 'https://randomuser.me/api/portraits/men/2.jpg'),
//         ],
//       ),
//       SkillModel(skill: 'Dart'),
//       SkillModel(skill: 'Mobile Development'),
//       SkillModel(skill: 'UI/UX Design'),
//       SkillModel(skill: 'Firebase'),
//     ],
//     experience: [
//       ExperienceModel(
//         title: 'Senior Flutter Developer',
//         company: 'Tech Innovations Inc.',
//         location: 'New York, NY',
//         startDate: '2020-01',
//         description: 'Leading mobile app development team, creating cross-platform applications using Flutter.',
//         employmentType: 'Full-time',
//         locationType: 'Hybrid',
//         companyPicUrl: 'https://logo.clearbit.com/techinnovations.com',
//       ),
//       ExperienceModel(
//         title: 'Mobile Developer',
//         company: 'Mobile Solutions LLC',
//         location: 'Boston, MA',
//         startDate: '2018-03',
//         endDate: '2019-12',
//         description: 'Developed native Android applications and helped transition to Flutter for cross-platform development.',
//         employmentType: 'Full-time',
//         locationType: 'On-site',
//       ),
//     ],
//     education: [
//       EducationModel(
//         school: 'Massachusetts Institute of Technology',
//         schoolPic: 'https://logo.clearbit.com/mit.edu',
//         degree: 'Master of Computer Science',
//         field: 'Software Engineering',
//         startDate: '2016-09',
//         endDate: '2018-05',
//         grade: '3.8 GPA',
//         description: 'Focused on mobile application development and UI/UX design.',
//       ),
//       EducationModel(
//         school: 'New York University',
//         schoolPic: 'https://logo.clearbit.com/nyu.edu',
//         degree: 'Bachelor of Science',
//         field: 'Computer Science',
//         startDate: '2012-09',
//         endDate: '2016-05',
//         grade: '3.6 GPA',
//         description: 'Completed with honors. Specialized in algorithms and data structures.',
//       ),
//     ],
//     certifications: [
//       CertificationModel(
//         name: 'Flutter Development Bootcamp',
//         issuingOrganization: 'Google',
//         issuingOrganizationPic: 'https://logo.clearbit.com/google.com',
//         issueDate: '2021-08',
//         expirationDate: '2024-08',
//       ),
//       CertificationModel(
//         name: 'AWS Certified Developer',
//         issuingOrganization: 'Amazon Web Services',
//         issueDate: '2020-06',
//         issuingOrganizationPic: 'https://logo.clearbit.com/aws.amazon.com',
//       ),
//     ],
//     visibility: 'public',
//   );

//   // Simulate network delay
//   Future<void> _delay() {
//     return Future.delayed(const Duration(milliseconds: 800));
//   }

//   @override
//   Future<ProfileModel> getProfile() async {
//     await _delay();
//     return _profile;
//   }

//   @override
//   Future<void> createProfile(ProfileModel profile) async {
//     await _delay();
//     _profile = profile;
//   }

//   @override
//   Future<void> updateProfile({
//     String? name,
//     String? profilePictureUrl,
//     String? coverPhoto,
//     String? resume,
//     String? headline,
//     String? bio,
//     String? location,
//     String? industry,
//   }) async {
//     await _delay();
    
//     _profile = _profile.copyWith(
//       name: name,
//       profilePicture: profilePictureUrl,
//       coverPhoto: coverPhoto,
//       resume: resume,
//       headline: headline,
//       bio: bio,
//       location: location,
//       industry: industry,
//     );
//   }

//   @override
//   Future<void> deleteProfilePicture() async {
//     await _delay();
//     _profile = _profile.copyWith(
//       profilePicture: null,
//     );
//   }

//   @override
//   Future<void> deleteCoverPhoto() async {
//     await _delay();
//     _profile = _profile.copyWith(
//       coverPhoto: null,
//     );
//   }

//   @override
//   Future<void> addExperience(ExperienceModel experience) async {
//     await _delay();
//     // Cast the list to the correct type and add the new experience
//     final List<ExperienceModel> currentExperiences = 
//         _profile.experience.map((e) => e as ExperienceModel).toList();
//     final newExperiences = [...currentExperiences, experience];
//     _profile = _profile.copyWith(experience: newExperiences);
//   }

//   @override
//   Future<void> updateExperience(ExperienceModel experience) async {
//     await _delay();
//     // Properly cast and update
//     final List<ExperienceModel> updatedExperiences = _profile.experience.map((e) {
//       final exp = e as ExperienceModel;
//       return (exp.title == experience.title && exp.company == experience.company) 
//           ? experience 
//           : exp;
//     }).toList();
//     _profile = _profile.copyWith(experience: updatedExperiences);
//   }

//   @override
//   Future<void> deleteExperience(String experienceId) async {
//     await _delay();
//     // Cast and filter
//     final List<ExperienceModel> filteredExperiences = _profile.experience
//         .where((exp) => (exp as ExperienceModel).title != experienceId)
//         .map((e) => e as ExperienceModel)
//         .toList();
//     _profile = _profile.copyWith(experience: filteredExperiences);
//   }

//   @override
//   Future<void> addEducation(EducationModel education) async {
//     await _delay();
//     // Cast the list to the correct type and add the new education
//     final List<EducationModel> currentEducation = 
//         _profile.education.map((e) => e as EducationModel).toList();
//     final newEducation = [...currentEducation, education];
//     _profile = _profile.copyWith(education: newEducation);
//   }

//   @override
//   Future<void> updateEducation(EducationModel education) async {
//     await _delay();
//     // Properly cast and update
//     final List<EducationModel> updatedEducation = _profile.education.map((e) {
//       final edu = e as EducationModel;
//       return (edu.school == education.school && edu.degree == education.degree) 
//           ? education 
//           : edu;
//     }).toList();
//     _profile = _profile.copyWith(education: updatedEducation);
//   }

//   @override
//   Future<void> deleteEducation(String educationId) async {
//     await _delay();
//     // Cast and filter
//     final List<EducationModel> filteredEducation = _profile.education
//         .where((edu) => (edu as EducationModel).school != educationId)
//         .map((e) => e as EducationModel)
//         .toList();
//     _profile = _profile.copyWith(education: filteredEducation);
//   }

//   @override
//   Future<void> addSkill(SkillModel skill) async {
//     await _delay();
//     // Cast the list to the correct type and add the new skill
//     final List<SkillModel> currentSkills = 
//         _profile.skills.map((s) => s as SkillModel).toList();
//     final newSkills = [...currentSkills, skill];
//     _profile = _profile.copyWith(skills: newSkills);
//   }

//   @override
//   Future<void> updateSkill(SkillModel skill) async {
//     await _delay();
//     // Properly cast and update
//     final List<SkillModel> updatedSkills = _profile.skills.map((s) {
//       final skillModel = s as SkillModel;
//       return skillModel.skill == skill.skill ? skill : skillModel;
//     }).toList();
//     _profile = _profile.copyWith(skills: updatedSkills);
//   }

//   @override
//   Future<void> deleteSkill(String skillId) async {
//     await _delay();
//     // Cast and filter
//     final List<SkillModel> filteredSkills = _profile.skills
//         .where((skill) => (skill as SkillModel).skill != skillId)
//         .map((s) => s as SkillModel)
//         .toList();
//     _profile = _profile.copyWith(skills: filteredSkills);
//   }

//   @override
//   Future<void> addCertification(CertificationModel certification) async {
//     await _delay();
//     // Cast the list to the correct type and add the new certification
//     final List<CertificationModel> currentCertifications = 
//         _profile.certifications.map((c) => c as CertificationModel).toList();
//     final newCertifications = [...currentCertifications, certification];
//     _profile = _profile.copyWith(certifications: newCertifications);
//   }

//   @override
//   Future<void> updateCertification(CertificationModel certification) async {
//     await _delay();
//     // Properly cast and update
//     final List<CertificationModel> updatedCertifications = _profile.certifications.map((c) {
//       final cert = c as CertificationModel;
//       return (cert.name == certification.name && 
//               cert.issuingOrganization == certification.issuingOrganization) 
//           ? certification 
//           : cert;
//     }).toList();
//     _profile = _profile.copyWith(certifications: updatedCertifications);
//   }

//   @override
//   Future<void> deleteCertification(String certificationId) async {
//     await _delay();
//     // Cast and filter
//     final List<CertificationModel> filteredCertifications = _profile.certifications
//         .where((cert) => (cert as CertificationModel).name != certificationId)
//         .map((c) => c as CertificationModel)
//         .toList();
//     _profile = _profile.copyWith(certifications: filteredCertifications);
//   }
// }