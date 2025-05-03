import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/errors/exceptions.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/profile/data/models/certification_model.dart';
import 'package:linkedin_clone/features/profile/data/models/education_model.dart';
import 'package:linkedin_clone/features/profile/data/models/endorsement_model.dart';
import 'package:linkedin_clone/features/profile/data/models/experience_model.dart';
import 'package:linkedin_clone/features/profile/data/models/profile_model.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_data_source.dart';
import 'package:linkedin_clone/features/profile/data/models/skill_model.dart';
import 'package:mime_type/mime_type.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({required this.baseUrl});

  // Helper method to get authorization headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw UnauthorizedException('No authentication token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Profile Management
  @override
  Future<ProfileModel> getProfile(String id) async {
    final headers = await _getAuthHeaders();
    final Uri uri = id==""
      ? Uri.parse('$baseUrl/profile')
      : Uri.parse('$baseUrl/profile/$id');
      
    final response = await http.get(
      uri,
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
    } else {
      throw ServerException('Failed to load profile');
    }
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
      body: json.encode(profile.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to create profile');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
      body: json.encode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update profile');
    }
  }

  // Profile components deletion
  @override
  Future<void> deleteProfilePicture() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/profile-picture'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete profile picture');
    }
  }

  @override
  Future<void> deleteCoverPhoto() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/cover-photo'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete cover photo');
    }
  }

  @override
  Future<void> deleteResume() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/resume'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete resume');
    }
  }

  @override
  Future<void> deleteHeadline() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/headline'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete headline');
    }
  }

  @override
  Future<void> deleteBio() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/bio'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete bio');
    }
  }

  @override
  Future<void> deleteLocation() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/location'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete location');
    }
  }

  @override
  Future<void> deleteIndustry() async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/industry'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete industry');
    }
  }

  // Skills management
  @override
  Future<void> addSkill(SkillModel skill) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/profile/skills'),
      headers: headers,
      body: json.encode(skill.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add skill');
    }
  }

  @override
  Future<void> updateSkill(String skillName, SkillModel skill) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/profile/skills/$skillName'),
      headers: headers,
      body: json.encode(skill.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update skill');
    }
  }

  @override
  Future<void> deleteSkill(String skillName) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/skills/$skillName'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete skill');
    }
  }

  // Education management
  @override
  Future<void> addEducation(EducationModel education) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/profile/education'),
      headers: headers,
      body: json.encode(education.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add education');
    }
  }

  @override
  Future<void> updateEducation(
    String educationId,
    EducationModel education,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/profile/education/$educationId'),
      headers: headers,
      body: json.encode(education.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update education');
    }
  }

  @override
  Future<void> deleteEducation(String educationId) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/education/$educationId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete education');
    }
  }

  // Certification management
  @override
  Future<void> addCertification(CertificationModel certification) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/profile/certification'),
      headers: headers,
      body: json.encode(certification.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add certification');
    }
  }

  @override
  Future<void> updateCertification(
    String certificationId,
    CertificationModel certification,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/profile/certification/$certificationId'),
      headers: headers,
      body: json.encode(certification.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update certification');
    }
  }

  @override
  Future<void> deleteCertification(String certificationId) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/certification/$certificationId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete certification');
    }
  }

  // Work experience management
  @override
  Future<void> addWorkExperience(ExperienceModel experience) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/profile/work-experience'),
      headers: headers,
      body: json.encode(experience.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException('Failed to add work experience');
    }
  }

  @override
  Future<void> updateWorkExperience(
    String workExperienceId,
    ExperienceModel experience,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/profile/work-experience/$workExperienceId'),
      headers: headers,
      body: json.encode(experience.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update work experience');
    }
  }

  @override
  Future<void> deleteWorkExperience(String workExperienceId) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/work-experience/$workExperienceId'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete work experience');
    }
  }

  // Additional profile features
  @override
  Future<List<dynamic>> getFollowedCompanies(String userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile/followed-companies/$userId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException('Failed to get followed companies');
    }
  }

  @override
  Future<List<dynamic>> getPosts(String userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile/posts/$userId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException('Failed to get posts');
    }
  }

  // Endorsements
  @override
  Future<List<EndorsementModel>> getSkillEndorsements(
    String userId,
    String skillName,
  ) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/profile/skill-endorsements/$userId?skill=$skillName'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> endorsementJson = json.decode(response.body);
      return endorsementJson
          .map((json) => EndorsementModel.fromJson(json))
          .toList();
    } else {
      throw ServerException('Failed to get skill endorsements');
    }
  }
}