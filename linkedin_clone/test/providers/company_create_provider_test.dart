import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  // Declare the mocks and provider
  late CompanyCreateProvider companyCreateProvider;
  late MockCompanyRepositoryImpl mockCompanyRepository;
  late MockUploadImageUseCase mockUploadImageUseCase;

  setUp(() {
    // Initialize the mock objects
    mockCompanyRepository = MockCompanyRepositoryImpl();
    mockUploadImageUseCase = MockUploadImageUseCase();

    // Create the provider with mocked dependencies
    companyCreateProvider = CompanyCreateProvider(
      companyRepository: mockCompanyRepository,
      uploadImageUseCase: mockUploadImageUseCase,
    );
  });

  group('CompanyCreateProvider', () {
    test('should not proceed if any required field is missing', () async {
      // Set only some of the required fields (missing companyType and companyIndustry)
      companyCreateProvider.setCompanyName('Company Name');
      companyCreateProvider.setCompanySize('Large');

      // Attempt to create the company
      final result = await companyCreateProvider.createCompany();

      // Since required fields like companyType and companyIndustry are missing, result should be null
      expect(result, null);

      // Verify that the repository create method was never called because required fields are missing
      verifyNever(mockCompanyRepository.createCompany(any));
    });

    test(
      'should successfully upload logo and banner images when fields are valid',
      () async {
        // Set all required fields and upload images
        companyCreateProvider.setCompanyName('Company Name');
        companyCreateProvider.setCompanySize('Large');
        companyCreateProvider.setCompanyType('Tech');
        companyCreateProvider.setCompanyIndustry('Software');
        companyCreateProvider.setCompanyLogo(XFile('logo.png'));
        companyCreateProvider.setCompanyBanner(XFile('banner.png'));

        // Mock the upload image use case to return URLs for the logo and banner
        when(
          mockUploadImageUseCase.execute(any),
        ).thenAnswer((_) async => 'imageUrl');

        // Mock the company repository to not throw any error on creation
        when(mockCompanyRepository.createCompany(any)).thenAnswer((_) async {});

        final result = await companyCreateProvider.createCompany();

        // Assert the result is not null
        expect(result, isNotNull);

        // Verify that the logo and banner URLs were uploaded
        when(
          mockUploadImageUseCase.execute(any),
        ).thenAnswer((_) async => 'imageUrl');

        // Verify that the company was created after image uploads
        verify(mockCompanyRepository.createCompany(any)).called(1);
      },
    );
  });
}
