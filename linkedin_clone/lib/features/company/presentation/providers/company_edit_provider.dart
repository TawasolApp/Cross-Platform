import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/update_company_details_use_case.dart';

class EditCompanyDetailsProvider with ChangeNotifier {
  final UpdateCompanyDetails updateCompanyDetails;
  bool _isLoading = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  XFile? _logoImage;
  XFile? _bannerImage;

  XFile? get logoImage => _logoImage;
  XFile? get bannerImage => _bannerImage;
  final AddAdminUseCase addAdminUseCase; // Add Admin Use Case

  // Method to pick an image (logo or banner)
  Future<void> pickImage(ImageSource source, bool isLogo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      XFile imageFile = XFile(pickedFile.path);

      if (isLogo) {
        _logoImage = imageFile;
      } else {
        _bannerImage = imageFile;
      }

      notifyListeners();
    }
  }

  EditCompanyDetailsProvider({
    required this.updateCompanyDetails,
    required this.addAdminUseCase,
  });

  Future<void> updateDetails(UpdateCompanyEntity updatedCompany,String companyId) async {
    _isLoading = true;
    _errorMessage = ""; // Reset any previous error
    notifyListeners();

    try {
      await updateCompanyDetails.execute(updatedCompany, companyId); // Pass the companyId to the use case
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

   Future<void> addAdminUser(String newUserId,String companyId) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      await addAdminUseCase(newUserId, companyId); 
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
