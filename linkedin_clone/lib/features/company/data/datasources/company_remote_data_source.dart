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

  Future<List<CompanyModel>> getRelatedCompanies(
    String companyId, {
    int page = 1,
    int limit = 4,
  }) async {
    print('Fetching related companies...');
    final token = await TokenService.getToken();
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/companies/$companyId/suggested?page=$page&limit=$limit',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response body for related companies: ${response.body}');
      print(
        'Response status code for related companies: ${response.statusCode}',
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

    // Decode existing company data
    final Map<String, dynamic> existingCompany = jsonDecode(response.body);
    print("Existing company data:");
    existingCompany.forEach((key, value) {
      print("$key: $value");
    });
    // Get the new data from the model
    final Map<String, dynamic> newCompanyData = company.toJson();

    // Compare and keep only changed fields
    final Map<String, dynamic> updatedData = {};
    newCompanyData.forEach((key, value) {
      final existingValue = existingCompany[key];

      // Only include the fields where the new value is different from the existing value.
      // Consider null as a valid update for fields that were cleared
      if (value != existingValue) {
        updatedData[key] = value;
      }
    });

    print(updatedData); // This will print the modified fields only.

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

  Future<List<CompanyModel>> getAllCompanies(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/companies?name=$query&page=$page&limit=$limit'),
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

  Future<List<UserModel>> fetchCompanyAdmins(
    String companyId, {
    int page = 1,
    int limit = 4,
  }) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }
    final response = await http.get(
      Uri.parse(
        '$baseUrl/companies/$companyId/managers?&page=$page&limit=$limit',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body for fetch admins: ${response.body}');
    print('Response status code for fetch admins: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server returns a successful response
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to load admins');
    }
  }

  Future<List<UserModel>> getFollowers(String companyId,{int page = 1,
    int limit = 5}) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/followers?&page=$page&limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body for fetch company followers: ${response.body}');
    if (response.statusCode == 200) {
      // If the server returns a successful response
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to load admins');
    }
  }
}
