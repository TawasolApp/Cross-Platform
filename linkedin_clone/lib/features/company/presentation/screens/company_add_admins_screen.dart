import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_edit_provider.dart';
import 'package:provider/provider.dart';

class AddAdminScreen extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditCompanyDetailsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: 'Admin User ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            provider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    if (userIdController.text.isEmpty) {
                      // Alert the user if the field is empty
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Please enter an Admin User ID.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                      );
                      return;
                    }

                    await provider.addAdminUser(userIdController.text);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    if (provider.errorMessage == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Admin added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Pop back to the previous screen
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Add Admin'),
                ),
          ],
        ),
      ),
    );
  }
}
