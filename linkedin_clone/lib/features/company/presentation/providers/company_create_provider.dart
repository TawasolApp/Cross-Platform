import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/data/models/company_create_model.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_create_entity.dart';

class CompanyCreateProvider with ChangeNotifier {
  final CompanyRepositoryImpl _companyRepository;

  CompanyCreateProvider({required CompanyRepositoryImpl companyRepository})
    : _companyRepository = companyRepository;

  // ✅ Create Company Form Fields
  String? _companyName;
  String? _companyDescription;
  String? _companyWebsite;
  String? _companyType;
  String? _companyIndustry;
  String? _companyOverview;
  int? _companyFounded;
  String? _companyAddress;
  String? _companyLocation;
  String? _companyEmail;
  String? _companyContactNumber;
  String? _companySize;
  String? _companySpecialities;
  XFile? _companyLogo;
  XFile? _companyBanner;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  // ✅ Getters
  String? get companyName => _companyName;
  String? get companyDescription => _companyDescription;
  String? get companyWebsite => _companyWebsite;
  String? get companyType => _companyType;
  String? get companyIndustry => _companyIndustry;
  String? get companyOverview => _companyOverview;
  int? get companyFounded => _companyFounded;
  String? get companyAddress => _companyAddress;
  String? get companyLocation => _companyLocation;
  String? get companyEmail => _companyEmail;
  String? get companyContactNumber => _companyContactNumber;
  String? get companySize => _companySize;
  String? get companySpecialities => _companySpecialities;
  XFile? get companyLogo => _companyLogo;
  XFile? get companyBanner => _companyBanner;
  bool get isLoading => _isLoading;
  bool get agreedToTerms => _agreedToTerms;

  // ✅ Setters
  void setCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void setCompanyDescription(String value) {
    _companyDescription = value;
    notifyListeners();
  }

  void setCompanyWebsite(String value) {
    _companyWebsite = value;
    notifyListeners();
  }

  void setCompanyType(String value) {
    _companyType = value;
    notifyListeners();
  }

  void setCompanyIndustry(String value) {
    _companyIndustry = value;
    notifyListeners();
  }

  void setCompanyOverview(String value) {
    _companyOverview = value;
    notifyListeners();
  }

  void setCompanyFounded(int value) {
    _companyFounded = value;
    notifyListeners();
  }

  void setCompanyAddress(String value) {
    _companyAddress = value;
    notifyListeners();
  }

  void setCompanyLocation(String value) {
    _companyLocation = value;
    notifyListeners();
  }

  void setCompanyEmail(String value) {
    _companyEmail = value;
    notifyListeners();
  }

  void setCompanyContactNumber(String value) {
    _companyContactNumber = value;
    notifyListeners();
  }

  void setCompanySize(String value) {
    _companySize = value;
    notifyListeners();
  }

  void setCompanySpecialities(String value) {
    _companySpecialities = value;
    notifyListeners();
  }

  void setCompanyLogo(XFile? image) {
    _companyLogo = image;
    notifyListeners();
  }

  void setCompanyBanner(XFile? image) {
    _companyBanner = image;
    notifyListeners();
  }

  void setAgreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  /// ✅ Creates a new company
  Future<CompanyCreateEntity?> createCompany() async {
    if (_companyName == null ||
        _companySize == null ||
        _companyType == null ||
        _companyIndustry == null) {
      print("❌ Missing required fields");
      return null;
    }

    _isLoading = true;
    notifyListeners();

    // ✅ Create Company instance
    final newCompany = CompanyCreateModel(
      name: _companyName!,
      logo: _companyLogo?.path ?? "",
      description: _companyDescription ?? "",
      companySize: _companySize ?? "",
      companyType: _companyType ?? "",
      industry: _companyIndustry ?? "",
      overview: _companyOverview ?? "",
      founded: _companyFounded ?? 0,
      website: _companyWebsite ?? "",
      address: _companyAddress ?? "",
      location: _companyLocation ?? "",
      email: _companyEmail ?? "",
      contactNumber: _companyContactNumber ?? "",
      banner: _companyBanner?.path ?? "",
    );

    try {
      await _companyRepository.createCompany(newCompany);
      print("✅ Company created successfully:\n");
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
