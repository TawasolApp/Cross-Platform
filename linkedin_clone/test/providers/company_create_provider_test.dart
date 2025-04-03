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
    expect(provider.companyName, null);
    expect(provider.companyDescription, null);
    expect(provider.companyWebsite, null);
  });

  test("setName updates provider", () {
    provider.setCompanyName("TechCorp");
    expect(provider.setCompanyName, "TechCorp");
  });

  test("Fails to create company if required fields are missing", () async {
    final result = await provider.createCompany();
    expect(result, null);
  });

  test("Successfully creates company", () async {
    provider.setCompanyName("TechCorp");
    provider.setCompanyDescription("A technology company");
    provider.setCompanyWebsite("https://techcorp.com");
    provider.setCompanyIndustry("Technology");
    provider.setCompanyLocation("New York");
    provider.setCompanySize("2-10 Employees");
    provider.setCompanyLogo(XFile("dummy_logo_path"));
    provider.setCompanyBanner(XFile("dummy_banner_path"));
    provider.setAgreedToTerms(true);

    when(mockRepository.createCompany(any)).thenAnswer(
      (_) async => Company(
        companyId: "1",
        name: provider.companyName!,
        isFollowing: false,
        isVerified: false,
        logo: provider.companyLogo!.path,
        description: provider.companyDescription!,
        companySize: provider.companySize ?? "",
        followers: 0,
        companyType: "Tech",
        industry: provider.companyIndustry ?? "",
        overview: "Overview of TechCorp",
        founded: "2020",
        website: provider.companyWebsite!,
        address: "123 Tech Street",
        location: provider.companyLocation!,
        email: "contact@techcorp.com",
        contactNumber: "123-456-7890",
        banner: provider.companyBanner?.path ?? "",
        specialities: "Software, AI, Cloud",
      ),
    );

    final result = await provider.createCompany();

    expect(result, isNotNull);
    expect(result?.name, "TechCorp");
  });
}
