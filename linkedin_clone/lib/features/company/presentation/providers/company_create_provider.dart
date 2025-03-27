import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';

class CompanyCreateProvider with ChangeNotifier {
  final CompanyRepositoryImpl _companyRepository;

  CompanyCreateProvider({required CompanyRepositoryImpl companyRepository})
    : _companyRepository = companyRepository;

  // ✅ Create Company Form Fields
  String? _name;
  String? _description;
  String? _website;
  String? _selectedIndustry;
  String? _selectedLocation;
  String? _selectedCompanySize; 
  XFile? _logoImage;
  XFile? _bannerImage;
  bool _isLoading = false;
  bool _agreedToTerms = false; 
  // ✅ Getters
  String? get name => _name;
  String? get description => _description;
  String? get website => _website;
  String? get selectedIndustry => _selectedIndustry;
  String? get selectedLocation => _selectedLocation;
  String? get selectedCompanySize => _selectedCompanySize; 
  XFile? get logoImage => _logoImage;
  XFile? get bannerImage => _bannerImage;
  bool get isLoading => _isLoading;
  bool get agreedToTerms => _agreedToTerms;
  // ✅ Setters
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setWebsite(String value) {
    _website = value;
    notifyListeners();
  }

  void setIndustry(String? value) {
    _selectedIndustry = value;
    notifyListeners();
  }

  void setLocation(String? value) {
    _selectedLocation = value;
    notifyListeners();
  }

  void setCompanySize(String? value) {
    _selectedCompanySize = value;
    notifyListeners();
  }

  void setLogoImage(XFile? image) {
    _logoImage = image;
    notifyListeners();
  }

  void setBannerImage(XFile? image) {
    _bannerImage = image;
    notifyListeners();
  }
  void setAgreedToTerms(bool value) { 
    _agreedToTerms = value;
    notifyListeners();
  }

  /// ✅ Creates a new company
  Future<Company?> createCompany() async {
    if (_name == null || _description == null || _logoImage == null) {
      print("❌ Missing required fields");
      return null;
    }

    _isLoading = true;
    notifyListeners();

    // ✅ Create Company instance
    final newCompany = Company(
      id: "", // The backend should generate an ID
      name: _name!,
      description: _description!,
      website: _website ?? "",
      bannerUrl: _bannerImage?.path ?? "",
      logoUrl: _logoImage!.path,
      field: _selectedIndustry ?? "",
      followerCount: 0,
      employeeCount:
          _selectedCompanySize != null
              ? int.tryParse(_selectedCompanySize!) ?? 0
              : 0, 
      location: _selectedLocation ?? "",
      followerIds: [],
    );

    try {
      await _companyRepository.createCompany(newCompany);
      print("✅ Company created successfully");
      notifyListeners();
      return newCompany;
    } catch (e) {
      print("❌ Error creating company: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
