import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_company_repository.mocks.dart';

void main() {
  late CompanyCreateProvider provider;
  late MockCompanyRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockCompanyRepositoryImpl();
    provider = CompanyCreateProvider(companyRepository: mockRepository);
  });

  test("Initial values should be null", () {
    expect(provider.name, null);
    expect(provider.description, null);
    expect(provider.website, null);
  });

  test("setName updates provider", () {
    provider.setName("TechCorp");
    expect(provider.name, "TechCorp");
  });

  test("Fails to create company if required fields are missing", () async {
    // Without setting required fields, createCompany should return null
    final result = await provider.createCompany();
    expect(result, null);
  });

  test("Successfully creates company", () async {
    // Setup required fields
    provider.setName("TechCorp");
    provider.setDescription("A technology company");
    provider.setWebsite("https://techcorp.com");
    provider.setIndustry("Technology");
    provider.setLocation("New York");
    provider.setCompanySize("2-10 Employees");
    // For testing, simulate image uploads with dummy paths.
    provider.setLogoImage(XFile("dummy_logo_path"));
    provider.setBannerImage(XFile("dummy_banner_path"));
    provider.setAgreedToTerms(true);

    // Setup the mock behavior for the repository's createCompany method.
    when(mockRepository.createCompany(any)).thenAnswer(
      (_) async => Company(
        id: "1",
        name: provider.name!,
        description: provider.description!,
        website: provider.website!,
        bannerUrl: provider.bannerImage?.path ?? "",
        logoUrl: provider.logoImage!.path,
        field: provider.selectedIndustry ?? "",
        followerCount: 0,
        employeeCount: int.tryParse(provider.selectedCompanySize ?? "0") ?? 0,
        location: provider.selectedLocation!,
        followerIds: [],
      ),
    );

    final result = await provider.createCompany();

    expect(result, isNotNull);
    expect(result?.name, "TechCorp");
  });
}
