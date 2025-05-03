import 'package:flutter/material.dart';
import '../../domain/entities/company.dart'; 
import '../screens/company_profile_screen.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: company.logo == null || company.logo!.isEmpty
            ? const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.business, color: Colors.white),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(company.logo!),
                backgroundColor: Colors.transparent,
              ),
        title: Text(
          company.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          company.industry,
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompanyProfileScreen(companyId: company.companyId!),
            ),
          );
        },
      ),
    );
  }
}
