import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/errors/exceptions.dart';
import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
// import 'package:linkedin_clone/features/profile/data/models/plan_details_model.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_data_source.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({required this.client, required this.baseUrl});

  /// Profile Management
  @override
  Future<ProfileModel> getProfile(String userId) async {
    final response = await client.get(Uri.parse('$baseUrl/profile/$userId'));
    if (response.statusCode == 200) {
      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
    } else {
      throw ServerException('Failed to load profile');
    }
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    final response = await client.post(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to create profile');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update profile');
    }
  }

  /// Profile Picture Management
  // @override
  // Future<String> uploadProfilePicture(String image) async {
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/profile/profile-picture'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'image': image}),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return data['profilePicUrl'];
  //   } else {
  //     throw ServerException('Failed to upload profile picture');
  //   }
  // }
  @override
  Future<void> deleteProfilePicture() async {
    final response = await client.delete(Uri.parse('$baseUrl/profile/profile-picture'));
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete profile picture');
    }
  }

  /// Cover Photo Management
  // @override
  // Future<String> uploadCoverPhoto(String image) async {
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/profile/cover-photo'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'image': image}),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return data['coverPhotoUrl'];
  //   } else {
  //     throw ServerException('Failed to upload cover photo');
  //   }
  // }

  @override
  Future<void> deleteCoverPhoto() async {
    final response = await client.delete(Uri.parse('$baseUrl/profile/cover-photo'));
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete cover photo');
    }
  }

  /// Experience Management
  // @override
  // Future<List<ExperienceModel>> getExperiences(String userId) async {
  //   final response = await client.get(Uri.parse('$baseUrl/profiles/$userId/experiences'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((item) => ExperienceModel.fromJson(item)).toList();
  //   } else {
  //     throw ServerException('Failed to load experiences');
  //   }
  // }

  @override
  Future<void> addExperience(ExperienceModel experience) async {
    final response = await client.post(
      Uri.parse('$baseUrl/profile/experience'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(experience.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add experience');
    }
  }

  @override
  Future<void> updateExperience(ExperienceModel experience) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profile/experience'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(experience.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update experience');
    }
  }

  @override
  Future<void> deleteExperience(String experience) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/profile/experience'),
    );
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete experience');
    }
  }

  /// Education Management
  // @override
  // Future<List<EducationModel>> getEducation(String userId) async {
  //   final response = await client.get(Uri.parse('$baseUrl/profiles/$userId/education'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((item) => EducationModel.fromJson(item)).toList();
  //   } else {
  //     throw ServerException('Failed to load education');
  //   }
  // }

  @override
  Future<void> addEducation(EducationModel education) async {
    final response = await client.post(
      Uri.parse('$baseUrl/profiles/education'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(education.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add education');
    }
  }

  @override
  Future<void> updateEducation(EducationModel education) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profiles/education'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(education.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update education');
    }
  }

  @override
  Future<void> deleteEducation(String education) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/profiles/education'),
    );
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete education');
    }
  }

  /// Skills Management
  // @override
  // Future<List<SkillModel>> getSkills(String userId) async {
  //   final response = await client.get(Uri.parse('$baseUrl/profiles/$userId/skills'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((item) => SkillModel.fromJson(item)).toList();
  //   } else {
  //     throw ServerException('Failed to load skills');
  //   }
  // }

  @override
  Future<void> addSkill(SkillModel skill) async {
    final response = await client.post(
      Uri.parse('$baseUrl/profiles/skills'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(skill.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add skill');
    }
  }

  @override
  Future<void> updateSkill(SkillModel skill) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profile/skills'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(skill.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update skill');
    }
  }

  @override
  Future<void> deleteSkill(String skill) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/profile/skills/$skill'),
    );
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete skill');
    }
  }

  /// Certification Management
  // @override
  // Future<List<CertificationModel>> getCertifications(String userId) async {
  //   final response = await client.get(Uri.parse('$baseUrl/profiles/$userId/certifications'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((item) => CertificationModel.fromJson(item)).toList();
  //   } else {
  //     throw ServerException('Failed to load certifications');
  //   }
  // }

  @override
  Future<void> addCertification(CertificationModel certification) async {
    final response = await client.post(
      Uri.parse('$baseUrl/profiles/certifications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(certification.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add certification');
    }
  }

  @override
  Future<void> updateCertification(CertificationModel certification) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profiles/certifications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(certification.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update certification');
    }
  }

  @override
  Future<void> deleteCertification(String certification) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/profiles/certifications'),
    );
    if (response.statusCode != 204) {
      throw ServerException('Failed to delete certification');
    }
  }

  /// Plan & Subscription Management
//   @override
//   Future<PlanDetailsModel> getPlanDetails(String userId) async {
//     final response = await client.get(Uri.parse('$baseUrl/profiles/$userId/plan-details'));
//     if (response.statusCode == 200) {
//       final planDetailsJson = json.decode(response.body);
//       return PlanDetailsModel.fromJson(planDetailsJson);
//     } else {
//       throw ServerException('Failed to load plan details');
//     }
//   }

//   @override
//   Future<void> updatePlan(String userId, PlanDetailsModel planDetails) async {
//     final response = await client.put(
//       Uri.parse('$baseUrl/profiles/$userId/plan-details'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(planDetails.toJson()),
//     );
//     if (response.statusCode != 200) {
//       throw ServerException('Failed to update plan details');
//     }
//   }
}