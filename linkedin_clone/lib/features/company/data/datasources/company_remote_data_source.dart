import 'package:dio/dio.dart';
import 'package:linkedin_clone/features/company/data/models/user_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import '../models/company_model.dart';
class CompanyRemoteDataSource {
    final Dio dio = Dio();

  Future<CompanyModel> getCompanyDetails(String companyId) async {
      // TODO: Replace this mock data with an API request once the backend is ready
    // Simulate an API call with a delay
// TODO: Fetch company details from the API.
    // Example: Use Dio or HttpClient to send a GET request.
    // API Endpoint Example: GET /companies/{companyId}/details
    // Mock API response
    final mockJson = {
      'id': companyId,
      'name': 'Tech Corp',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada.'*100,
      'website': 'https://techcorp.com',
      'bannerUrl': 'https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png',
      'logoUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2nu6hy93FEDwYnsCt8Ye2wB_5NmEAyrN_Hg&s=10',
      'field': 'Technology',
      'followerCount': 1000,
      'employeeCount': 5000,
      'location': 'San Francisco, CA',
    };

    return CompanyModel.fromJson(mockJson);
  }

  Future<List<UserModel>> fetchCompanyFollowers(String companyId) async {
    // TODO: Replace this mock data with an API request once the backend is ready
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));
    // TODO: Fetch company details from the API.
    // Example: Use Dio or HttpClient to send a GET request.
    // API Endpoint Example: GET /companies/{companyId}/followers
    final mockUsers = [
      {
        "id": "user1",
        "name": "Alice Johnson",
        "profilePicture": "https://randomuser.me/api/portraits/women/1.jpg",
        "jobTitle": "Software Engineer"
      },
      {
        "id": "user2",
        "name": "Bob Smith",
        "profilePicture": "https://randomuser.me/api/portraits/men/2.jpg",
        "jobTitle": "Data Scientist"
      },
      {
        "id": "user3",
        "name": "Charlie Brown",
        "profilePicture": "https://randomuser.me/api/portraits/men/3.jpg",
        "jobTitle": "Product Manager"
      }
    ];

    return mockUsers.map((userJson) => UserModel.fromJson(userJson)).toList();
  }
  Future<List<CompanyModel>> getRelatedCompanies(String companyId) async {
    // TODO: Replace this mock data with an API request once the backend is ready
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));
    // TODO: Fetch related companies from the API.
    // Example: Use Dio or HttpClient to send a GET request.
    // API Endpoint Example: GET /companies/{companyId}/related
    final mockRelatedCompanies = [
      {
        'id': 'company2',
        'name': 'Innovatech',
        'description': 'Innovatech is a leading company in innovative technology solutions.',
        'website': 'https://innovatech.com',
        'bannerUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'logoUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'field': 'Technology',
        'followerCount': 800,
        'employeeCount': 3000,
        'location': 'New York, NY',
      },
      {
        'id': 'company3',
        'name': 'Future Solutions',
        'description': 'Future Solutions specializes in futuristic technology and services.',
        'website': 'https://futuresolutions.com',
        'bannerUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'logoUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'field': 'Technology',
        'followerCount': 1200,
        'employeeCount': 4000,
        'location': 'Los Angeles, CA',
      },
      {
        'id': 'company4',
        'name': 'GreenTech',
        'description': 'GreenTech is a pioneer in sustainable technology solutions.',
        'website': 'https://greentech.com',
        'bannerUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'logoUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'field': 'Technology',
        'followerCount': 1500,
        'employeeCount': 3500,
        'location': 'Austin, TX',
      },
      {
        'id': 'company5',
        'name': 'NextGen Innovations',
        'description': 'NextGen Innovations focuses on next-generation technological advancements.',
        'website': 'https://nextgen.com',
        'bannerUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'logoUrl': 'https://innovatechgroup-eg.com/images/logo@2x.png',
        'field': 'Technology',
        'followerCount': 2000,
        'employeeCount': 4500,
        'location': 'Seattle, WA',
      }
    ];

    return mockRelatedCompanies.map((companyJson) => CompanyModel.fromJson(companyJson)).toList();
  }

//POST Request
 Future<void> createCompany(Company company) async {
    // TODO: Replace this mock data with an API request once the backend is ready
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay

    // Log data to simulate API request
    print("Company Created: ${company.name} --form data layer");
  }

}