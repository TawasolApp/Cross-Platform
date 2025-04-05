import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linkedin_clone/features/company/data/models/company_create_model.dart';
import 'package:linkedin_clone/features/company/data/models/company_edit_model.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';
import '../models/company_model.dart';
import 'package:linkedin_clone/core/services/token_service.dart';

class CompanyRemoteDataSource {
  final String baseUrl = "https://tawasolapp.me/api";
  Future<CompanyModel> getCompanyDetails(String companyId) async {
    // API Endpoint Example: GET /companies/{companyId}/

    final token = await TokenService.getToken();
    print("Token: $token");
    if (token == null) {
      throw Exception('Token is missing');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      return CompanyModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Company details not found');
    } else {
      throw Exception('Failed to load company details');
    }
  }

  Future<List<UserModel>> fetchCompanyFollowers(String companyId) async {
    // TODO: Replace this mock api call with an API request once the backend is ready
    // Simulate API call delay
    // final response = await http.get(Uri.parse('http://192.168.1.100:3000/companies/elsewedy-electric/followers'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body);
    //   return data.map((userJson) => UserModel.fromJson(userJson)).toList();
    // } else {
    //   throw Exception('Failed to load company followers');
    // }

    // Mock followers data
    List<UserModel> followers = [
      UserModel(
        userId: "user1",
        username: "John Doe",
        profilePicture: "https://randomuser.me/api/portraits/women/1.jpg",
        headline: "Software Engineer at TechCorp",
      ),
      UserModel(
        userId: "user2",
        username: "Jane Smith",
        profilePicture: "https://randomuser.me/api/portraits/men/2.jpg",
        headline: "Product Manager at InnovateX",
      ),
      UserModel(
        userId: "user3",
        username: "Ali Ahmed",
        profilePicture: "https://randomuser.me/api/portraits/men/3.jpg",
        headline: "Data Scientist at AI Labs",
      ),
    ];

    return followers;
  }

  Future<List<CompanyModel>> getRelatedCompanies(String companyId) async {
    // TODO: Replace this mock data with an API request once the backend is ready
    final token = await TokenService.getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/companies/$companyId/suggested'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Print each company for debugging
        print('Fetched related companies:');
        for (var companyJson in data) {
          print(companyJson);
        }
        return data.map((json) => CompanyModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load related companies (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching related companies: $e');
      throw Exception('Something went wrong while fetching related companies.');
    }
  }

  // POST Request to create a company
  Future<void> createCompany(CompanyCreateModel company) async {
    final token = await TokenService.getToken();
    print("Creating company: ${company.toJson()}");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/companies/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(company.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Company created successfully');
        print('Response body: ${response.body}');
      } else {
        print(
          '❌ Failed to create company. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        throw Exception('Failed to create company');
      }
    } catch (e) {
      print('⚠️ Exception occurred: $e');
      throw Exception('Something went wrong while creating the company');
    }
  }

  // PUT Request to update company details
  Future<void> updateCompanyDetails(
    UpdateCompanyModel company,
    String companyId,
  ) async {
    final url = Uri.parse('$baseUrl/companies/$companyId');
    final token = await TokenService.getToken();

    // Fetch the existing company details
    final response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch company data');
    }

    // Parse the existing company data
    Map<String, dynamic> existingCompany = jsonDecode(response.body);

    // Prepare a map for the fields that have changed
    final Map<String, dynamic> updatedData = {};

    // Only update fields that have changed
    if (company.name != null && company.name != existingCompany['name']) {
      updatedData['name'] = company.name;
    }
    if (company.companySize != null &&
        company.companySize != existingCompany['companySize']) {
      updatedData['companySize'] = company.companySize;
    }
    if (company.logo != '' && company.logo != existingCompany['logo']) {
      updatedData['logo'] = company.logo;
    }
    if (company.description != null &&
        company.description != existingCompany['description']) {
      updatedData['description'] = company.description;
    }
    if (company.overview != null &&
        company.overview != existingCompany['overview']) {
      updatedData['overview'] = company.overview;
    }
    if (company.founded != null &&
        company.founded != existingCompany['founded']) {
      updatedData['founded'] = company.founded;
    }
    if (company.website != null &&
        company.website != existingCompany['website']) {
      updatedData['website'] = company.website;
    }
    if (company.address != null &&
        company.address != existingCompany['address']) {
      updatedData['address'] = company.address;
    }
    if (company.location != null &&
        company.location != existingCompany['location']) {
      updatedData['location'] = company.location;
    }
    if (company.email != null && company.email != existingCompany['email']) {
      updatedData['email'] = company.email;
    }
    if (company.contactNumber != null &&
        company.contactNumber != existingCompany['contactNumber']) {
      updatedData['contactNumber'] = company.contactNumber;
    }
    if (company.banner != '' && company.banner != existingCompany['banner']) {
      updatedData['banner'] = company.banner;
    }
    if (company.companyType != null &&
        company.companyType != existingCompany['companyType']) {
      updatedData['companyType'] = company.companyType;
    }
    if (company.industry != null &&
        company.industry != existingCompany['industry']) {
      updatedData['industry'] = company.industry;
    }
    if (company.isVerified != null &&
        company.isVerified != existingCompany['isVerified']) {
      updatedData['isVerified'] = company.isVerified;
    }

    // If no fields have changed, do not send an update request
    if (updatedData.isEmpty) {
      print("No fields have changed. Skipping update.");
      return;
    }

    // Prepare updated JSON for the PATCH request
    final updatedCompanyJson = jsonEncode(updatedData);
    print("Updated company JSON: $updatedCompanyJson");
    // Send the PATCH request to update company details
    final patchResponse = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: updatedCompanyJson,
    );
    print("Patch response: ${patchResponse.body}");
    if (patchResponse.statusCode == 200) {
      print("✅ Company details updated successfully.");
    } else {
      print("❌ Failed to update company: ${patchResponse.statusCode}");
      throw Exception('Update failed: ${patchResponse.body}');
    }
  }

  Future<List<CompanyModel>> getAllCompanies() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/companies?name=e'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }
}
