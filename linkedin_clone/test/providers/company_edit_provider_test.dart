// import 'package:flutter_test/flutter_test.dart';
// import 'package:linkedin_clone/features/company/presentation/providers/company_edit_provider.dart';
// import 'package:mockito/mockito.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
// import 'company_edit_provider_test.mocks.dart';
// // Generate the mock classes

// void main() {
//   // Ensure widget binding is initialized for image picking
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late EditCompanyDetailsProvider editCompanyDetailsProvider;
//   late MockUpdateCompanyDetails mockUpdateCompanyDetails;
//   late XFile mockLogoImage;
//   late XFile mockBannerImage;

//   setUp(() {
//     mockUpdateCompanyDetails = MockUpdateCompanyDetails();
//     editCompanyDetailsProvider = EditCompanyDetailsProvider(
//       updateCompanyDetails: mockUpdateCompanyDetails,
//     );

//     mockLogoImage = XFile('logo.png');
//     mockBannerImage = XFile('banner.png');
//   });

//   group('EditCompanyDetailsProvider', () {

//     test(
//       'should call updateCompanyDetails.execute with correct parameters when fields are valid',
//       () async {
//         final updatedCompany = UpdateCompanyEntity(
//           name: 'Company Name',
//           industry: 'Software',
//           companySize: 'Large',
//           companyType: 'Tech',
//           contactNumber: '',
//           description: '',
//           isVerified: false,
//           logo: '',
//           banner: '',
//           overview: '',
//           location: '',
//           founded: 2000,
//           website: '',
//           address: '',
//           email: '',
//         );

//         when(
//           mockUpdateCompanyDetails.execute(any, any),
//         ).thenAnswer((_) async {});

//         // Call the update details method
//         await editCompanyDetailsProvider.updateDetails(
//           updatedCompany,
//           'companyId',
//         );

//         // Verify that the updateCompanyDetails.execute was called
//         verify(
//           mockUpdateCompanyDetails.execute(updatedCompany, 'companyId'),
//         ).called(1);
//         expect(editCompanyDetailsProvider.isLoading, false);
//       },
//     );

//     test(
//       'should handle errors when updateCompanyDetails.execute throws an error',
//       () async {
//         final updatedCompany = UpdateCompanyEntity(
//           name: 'Company Name',
//           industry: 'Software',
//           companySize: 'Large',
//           companyType: 'Tech',
//           contactNumber: '',
//           description: '',
//           isVerified: false,
//           logo: '',
//           banner: '',
//           overview: '',
//           location: '',
//           founded: 2000,
//           website: '',
//           address: '',
//           email: '',
//         );

//         when(
//           mockUpdateCompanyDetails.execute(any, any),
//         ).thenThrow(Exception('Update failed'));

//         await editCompanyDetailsProvider.updateDetails(
//           updatedCompany,
//           'companyId',
//         );

//         // Verify the loading state and error message
//         expect(editCompanyDetailsProvider.isLoading, false);
//         expect(
//           editCompanyDetailsProvider.errorMessage,
//           'Exception: Update failed',
//         );
//       },
//     );

//     test('should not update details if any required field is empty', () async {
//       final updatedCompany = UpdateCompanyEntity(
//         name: '', // Invalid name
//         industry: 'Software',
//         companySize: 'Large',
//         companyType: 'Tech',
//         contactNumber: '',
//         description: '',
//         isVerified: false,
//         logo: '',
//         banner: '',
//         overview: '',
//         location: '',
//         founded: 2000,
//         website: '',
//         address: '',
//         email: '',
//       );

//       await editCompanyDetailsProvider.updateDetails(
//         updatedCompany,
//         'companyId',
//       );

//       // Verify the loading state and error message for missing required field
//       expect(editCompanyDetailsProvider.isLoading, false);
//       expect(editCompanyDetailsProvider.errorMessage, '');
//     });

//     test('should set error message if a required field is empty', () async {
//       final updatedCompany = UpdateCompanyEntity(
//         name: '', // Invalid name
//         industry: 'Software',
//         companySize: 'Large',
//         companyType: 'Tech',
//         contactNumber: '',
//         description: '',
//         isVerified: false,
//         logo: '',
//         banner: '',
//         overview: '',
//         location: '',
//         founded: 2000,
//         website: '',
//         address: '',
//         email: '',
//       );

//       await editCompanyDetailsProvider.updateDetails(
//         updatedCompany,
//         'companyId',
//       );

//       expect(editCompanyDetailsProvider.errorMessage, '');
//     });
//   });
// }
