import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_admins_provider.dart';

class AddAdminScreen extends StatefulWidget {
  final String companyId;

  const AddAdminScreen({Key? key, required this.companyId}) : super(key: key);

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Add Admin')),
      body: Consumer<CompanyAdminsProvider>(
        builder: (context, provider, _) {
          final filteredUsers =
              provider.users.where((user) {
                return !provider.companyAdmins.any(
                  (admin) => admin.userId == user.userId,
                );
              }).toList();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                    provider.searchUsers(query);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search for user by name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Search results
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                        provider.isLoading && filteredUsers.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : filteredUsers.isEmpty
                            ? const Center(child: Text('No users found.'))
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Search Results:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredUsers.length,
                                    itemBuilder: (context, index) {
                                      final user = filteredUsers[index];
                                      return buildUserTile(
                                        user,
                                        onTap: () async {
                                          await provider.addAdmin(
                                            user.userId,
                                            widget.companyId,
                                          );
                                          if (provider.errorMessage.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Admin added successfully!',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.errorMessage,
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(height: 20),
                // Company admins section
                if (!provider.isLoading && provider.companyAdmins.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Company Admins:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...provider.companyAdmins.map(
                        (admin) => buildUserTile(admin),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildUserTile(User user, {VoidCallback? onTap}) {
  final imageUrl = user.profilePicture;

  return ListTile(
    leading:
        imageUrl != null && imageUrl.isNotEmpty
            ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
            : const CircleAvatar(child: Icon(Icons.person)),
    title: Text('${user.firstName} ${user.lastName}'),
    subtitle: Text(user.headline),
    trailing:
        onTap != null
            ? IconButton(
              icon: const Icon(Icons.person_add_alt_1),
              color: Colors.blue,
              onPressed: onTap,
              tooltip: 'Add as admin',
            )
            : null,
    onTap:
        onTap == null
            ? null
            : () {}, // prevent full-tile tap if using trailing icon
  );
}
