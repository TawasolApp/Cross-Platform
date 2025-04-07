import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_admins_provider.dart';

class AddAdminScreen extends StatefulWidget {
  final String companyId;

  const AddAdminScreen({Key? key, required this.companyId}) : super(key: key);

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CompanyAdminsProvider>(
        context,
        listen: false,
      ).fetchAdmins(widget.companyId);
    });
  }

  @override
  void dispose() {
    userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Admin')),
      body: Consumer<CompanyAdminsProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    labelText: 'Admin User ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                provider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () async {
                        final userId = userIdController.text.trim();
                        if (userId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter an Admin User ID'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        await provider.addAdmin(userId, widget.companyId);

                        if (provider.errorMessage.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Admin added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          userIdController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Add Admin'),
                    ),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : provider.companyAdmins.isEmpty
                          ? const Center(child: Text('No admins found.'))
                          : ListView.builder(
                            itemCount: provider.companyAdmins.length,
                            itemBuilder: (context, index) {
                              final admin = provider.companyAdmins[index];
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text('${admin.firstName} ${admin.lastName}'),

                                subtitle: Text(admin.userId),
                              );
                            },
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
