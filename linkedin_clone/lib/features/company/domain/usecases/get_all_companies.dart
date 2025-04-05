import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/repositories/company_repository.dart';

class GetAllCompanies {
  final CompanyRepository repository;

  GetAllCompanies({required this.repository});

  Future<List<Company>> execute() async {
    return await repository.getAllCompanies();
  }
}