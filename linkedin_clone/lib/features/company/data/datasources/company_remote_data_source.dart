import 'package:linkedin_clone/features/company/data/models/user_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import '../models/company_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyRemoteDataSource {

  Future<CompanyModel> getCompanyDetails(String companyId) async {
    // TODO: Replace this mock api call with an API request once the backend is ready
    // API Endpoint Example: GET /companies/{companyId}/details
    // final response = await http.get(Uri.parse('http://192.168.1.6:3000/companies/elsewedy-electric'));
    // if (response.statusCode == 200) {
    //   return CompanyModel.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Failed to load company details');
    // }
 await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  
  return CompanyModel(
    companyId: companyId,
    name: "Elsewedy Electric",
    isFollowing: true,
    isVerified: true,
    logo: "https://media.licdn.com/dms/image/v2/C560BAQF2a3ilv6hXXw/company-logo_200_200/company-logo_200_200/0/1631303609923?e=1747872000&v=beta&t=M9wVeJt_Zk6nNOEnz5X6PQVoUzb8wzaSFYK9JeRNA60",
    description: "Manufacturer of Cables & Electrical Products and Integrated Infrastructure Provider",
    companySize: "201-500 Employees",
    followers: 1000,
    companyType: "Public Company",
    industry: "Appliances, Electrical and Electronics",
    overview: "A global leader that has evolved from a local manufacturer of electrical products into an integrated infrastructure solutions provider"*10,
    founded: '1955',
    website: "https://elsewedyelectric.com/en/default",
    address: "New Cairo, Cairo",
    location: "https://maps.app.goo.gl/fEh4pBYt6LvTFxQE8",
    email: "user@example.com",
    contactNumber: "19159",
    banner:'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
    specialities: "Cables & Accessories"
  );



    
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
      overview: "Schneider Electric provides digital energy and automation solutions...",
      founded: '1836',
      website: "https://www.se.com",
      address: "Rueil-Malmaison, France",
      location: "https://maps.app.goo.gl/schneider",
      email: "contact@se.com",
      contactNumber: "+33 1 41 29 70 00",
      banner:'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
       specialities: '',

    ),
    CompanyModel(
      companyId: "siemens",
      name: "Siemens",
      isFollowing: true,
      isVerified: true,
      logo: "https://innovatechgroup-eg.com/images/logo@2x.png",
      description: "A leading technology company specializing in industrial automation and digitalization.",
      companySize: "300,000+ Employees",
      followers: 8000,
      companyType: "Public Company",
      industry: "Industrial Automation, Electrical Engineering",
      overview: "Siemens AG is a German multinational company focusing on electrification"*10,
      founded: '1847',
      website: "https://www.siemens.com",
      address: "Munich, Germany",
      location: "https://maps.app.goo.gl/siemens",
      email: "info@siemens.com",
      contactNumber: "+49 89 636 00",
      banner:'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
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
}