import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linkedin_clone/features/company/data/models/company_edit_model.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';
import '../models/company_model.dart';
import 'package:linkedin_clone/core/services/token_service.dart'; // Import the TokenService class

class CompanyRemoteDataSource {
  final String baseUrl =
      "https://tawasolapp.me/api"; // Updated to use the provided base URL
  Future<CompanyModel> getCompanyDetails(String companyId) async {
    // TODO: Replace this mock api call with an API request once the backend is ready
  //   // API Endpoint Example: GET /companies/{companyId}/

    final token = await TokenService.getToken();
    print("Token: $token");
    if (token == null) {
      throw Exception('Token is missing');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/companies/$companyId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Use actual access token if needed
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
// final response = await http.get(
//       Uri.parse(
//         'http://192.168.1.6:3000/companies?companyId=elsewedy-electric',
//       ),
//     );
//     print(response.body);
//     if (response.statusCode == 200) {
//       return CompanyModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load company details');
//     }







  // await Future.delayed(Duration(seconds: 1)); // Simulate network delay

  // return CompanyModel(
  //   companyId: companyId,
  //   name: "Elsewedy Electric",
  //   isFollowing: true,
  //   isVerified: true,
  //   logo:
  //       "https://media.licdn.com/dms/image/v2/C560BAQF2a3ilv6hXXw/company-logo_200_200/company-logo_200_200/0/1631303609923?e=1747872000&v=beta&t=M9wVeJt_Zk6nNOEnz5X6PQVoUzb8wzaSFYK9JeRNA60",
  //   description:
  //       "Manufacturer of Cables & Electrical Products and Integrated Infrastructure Provider",
  //   companySize: "201-500 Employees",
  //   followers: 1000,
  //   companyType: "Public Company",
  //   industry: "Appliances, Electrical and Electronics",
  //   overview:
  //       "A global leader that has evolved from a local manufacturer of electrical products into an integrated infrastructure solutions provider" *
  //       10,
  //   founded: '1955',
  //   website: "https://elsewedyelectric.com/en/default",
  //   address: "New Cairo, Cairo",
  //   location: "https://maps.app.goo.gl/fEh4pBYt6LvTFxQE8",
  //   email: "user@example.com",
  //   contactNumber: "19159",
  //   banner:
  //       'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
  //   specialities: "Cables & Accessories",
  //   isAdmin: true,
  // );
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
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    // final response = await http.get(Uri.parse('http://192.168.1.100:3000/companies/elsewedy-electric/related'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body);
    //   return data.map((companyJson) => CompanyModel.fromJson(companyJson)).toList();
    // } else {
    //   throw Exception('Failed to load related companies');
    // }

    // Mock related companies data
    List<CompanyModel> relatedCompanies = [
      CompanyModel(
        companyId: "schneider-electric",
        name: "Schneider Electric",
        isFollowing: false,
        isVerified: true,
        logo: "https://innovatechgroup-eg.com/images/logo@2x.png",
        description: "Global specialist in energy management and automation.",
        companySize: "10,000+ Employees",
        followers: 5000,
        companyType: "Public Company",
        industry: "Energy, Electrical and Electronics",
        overview:
            "Schneider Electric provides digital energy and automation solutions...",
        founded: 1836,
        website: "https://www.se.com",
        address: "Rueil-Malmaison, France",
        location: "https://maps.app.goo.gl/schneider",
        email: "contact@se.com",
        contactNumber: "+33 1 41 29 70 00",
        banner:
            'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
        specialities: '',
      ),
      CompanyModel(
        companyId: "siemens",
        name: "Siemens",
        isFollowing: true,
        isVerified: true,
        logo: "https://innovatechgroup-eg.com/images/logo@2x.png",
        description:
            "A leading technology company specializing in industrial automation and digitalization.",
        companySize: "300,000+ Employees",
        followers: 8000,
        companyType: "Public Company",
        industry: "Industrial Automation, Electrical Engineering",
        overview:
            "Siemens AG is a German multinational company focusing on electrification" *
            10,
        founded: 1847,
        website: "https://www.siemens.com",
        address: "Munich, Germany",
        location: "https://maps.app.goo.gl/siemens",
        email: "info@siemens.com",
        contactNumber: "+49 89 636 00",
        banner:
            'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
        specialities: '',
      ),
    ];

    return relatedCompanies;
  }

  // POST Request to create a company
  Future<void> createCompany(CompanyModel company) async {
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay
    // TODO: Replace this mock api call with an API request once the backend is ready
    //   final response = await http.post(
    //     Uri.parse('http://192.168.1.100:3000/companies/create'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(company.toJson()),
    //   );

    //   if (response.statusCode != 201) {
    //     throw Exception('Failed to create company');
    //   }
  }

  // PUT Request to update company details
  Future<void> updateCompanyDetails(UpdateCompanyModel company) async {
    // Simulating network delay
    await Future.delayed(Duration(seconds: 2));

    // Hardcoded companyId
    final String companyId = 'elsewedy-electric';

    // Base URL for your JSON Server

    // Corrected URL to directly access the company entry
    final url = Uri.parse(
      'http://192.168.1.6:3000/companies?companyId=${companyId}',
    );

    // Fetch the existing company details
    final response = await http.get(url);

    print("Existing Company Data: ${response.body}");

    if (response.statusCode == 200) {
      // Parse the existing company data
      Map<String, dynamic> existingCompany = jsonDecode(response.body);

      // Merge only non-null fields from UpdateCompanyModel
      if (company.name != null) existingCompany['name'] = company.name;
      if (company.companySize != null)
        existingCompany['companySize'] = company.companySize;
      if (company.logo != null) existingCompany['logo'] = company.logo;
      if (company.description != null)
        existingCompany['description'] = company.description;
      if (company.overview != null)
        existingCompany['overview'] = company.overview;
      if (company.founded != null) existingCompany['founded'] = company.founded;
      if (company.website != null) existingCompany['website'] = company.website;
      if (company.address != null) existingCompany['address'] = company.address;
      if (company.location != null)
        existingCompany['location'] = company.location;
      if (company.email != null) existingCompany['email'] = company.email;
      if (company.contactNumber != null)
        existingCompany['contactNumber'] = company.contactNumber;
      if (company.banner != null) existingCompany['banner'] = company.banner;
      if (company.companyType != null)
        existingCompany['companyType'] = company.companyType;
      if (company.industry != null)
        existingCompany['industry'] = company.industry;

      // Set isVerified explicitly to true
      existingCompany['isVerified'] = true;

      // Prepare updated JSON
      final updatedCompanyJson = jsonEncode(existingCompany);

      // Send the PUT request to update company details
      final updateResponse = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: updatedCompanyJson,
      );

      if (updateResponse.statusCode == 200) {
        print("Company details updated successfully: ${company.name}");
      } else {
        throw Exception(
          'Failed to update company details: ${updateResponse.body}',
        );
      }
    } else {
      throw Exception('Failed to fetch company details: ${response.body}');
    }
  }
}
