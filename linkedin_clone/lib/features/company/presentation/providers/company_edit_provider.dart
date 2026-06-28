import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/usecases/update_company_details_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/upload_image_use_case.dart';

class EditCompanyDetailsProvider with ChangeNotifier {
  final UpdateCompanyDetails updateCompanyDetails;
  final UploadImageUseCase uploadImageUseCase;
  bool _isLoading = false;
  String _errorMessage = "";
  List<User> companyAdmins = [];
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  XFile? _logoImage;
  XFile? _bannerImage;

  XFile? get logoImage => _logoImage;
  XFile? get bannerImage => _bannerImage;
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
    required this.uploadImageUseCase,
  });

  Future<void> updateDetails(
    UpdateCompanyEntity updatedCompany,
    String companyId,
  ) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      // ✅ Upload logo image if provided
      String? logoUrl =
          _logoImage != null
              ? await uploadImageUseCase.execute(_logoImage!)
              : null;

      // ✅ Upload banner image if provided
      String? bannerUrl =
          _bannerImage != null
              ? await uploadImageUseCase.execute(_bannerImage!)
              : null;

      final newCompany = UpdateCompanyEntity(
        name: updatedCompany.name,
        description: updatedCompany.description,
        companySize: updatedCompany.companySize,
        location: updatedCompany.location,
        email: updatedCompany.email,
        companyType: updatedCompany.companyType,
        industry: updatedCompany.industry,
        overview: updatedCompany.overview,
        founded: updatedCompany.founded,
        website: updatedCompany.website,
        address: updatedCompany.address,
        contactNumber: updatedCompany.contactNumber,
        logo: logoUrl ?? updatedCompany.logo,
        banner: bannerUrl ?? updatedCompany.banner,
        isVerified: updatedCompany.isVerified,
      );

      await updateCompanyDetails.execute(newCompany, companyId);
      print("✅ Company updated successfully");
    } catch (e) {
      _errorMessage = "❌ Failed to update: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
