import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class AddCertificationPage extends StatefulWidget {
  const AddCertificationPage({super.key});

  @override
  State<AddCertificationPage> createState() => _AddCertificationPageState();
}

class _AddCertificationPageState extends State<AddCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuingOrgController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _isCurrentlyValid = false;
  bool _isSaving = false;
  bool _isCustomCompany = false;
  String? _selectedCompanyId;
  String? _selectedCompanyLogo;

  final FocusNode _companyFocusNode = FocusNode();
  final List<String> _companyResults = [];

  @override
  void initState() {
    super.initState();
    _companyFocusNode.addListener(_onCompanyFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingOrgController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _companyFocusNode.dispose();
    super.dispose();
  }

  void _onCompanyFocusChange() {
    if (_companyFocusNode.hasFocus) {
      _searchCompanies(_issuingOrgController.text);
    }
  }

  void _onCompanyTextChanged(String text) {
    _searchCompanies(text);
  }

  void _useCustomCompany() {
    setState(() {
      _isCustomCompany = true;
      _selectedCompanyId = null;
      _selectedCompanyLogo = null;
    });
  }

  Future<void> _searchCompanies(String query) async {
    // Implement your company search logic here
    // For now, we'll just simulate a search with a delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _companyResults.clear();
      if (query.isNotEmpty) {
        _companyResults.addAll(['Company A', 'Company B', 'Company C']);
      }
    });
  }

  void _selectCompany(String companyId, String companyLogo) {
    setState(() {
      _isCustomCompany = false;
      _selectedCompanyId = companyId;
      _selectedCompanyLogo = companyLogo;
    });
  }

  Widget _buildCompanyResults() {
    if (_companyResults.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _companyResults.length,
      itemBuilder: (context, index) {
        final company = _companyResults[index];
        return ListTile(
          title: Text(company),
          onTap: () => _selectCompany('companyId_$index', 'companyLogo_$index'),
        );
      },
    );
  }

  Widget _buildCompanySelectionIndicator() {
    if (_isCustomCompany) {
      return const SizedBox.shrink();
    }
    return ListTile(
      title: Text(_issuingOrgController.text),
      subtitle: const Text('Selected from search results'),
      trailing: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: _useCustomCompany,
      ),
    );
  }

  Future<void> _saveCertification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      String? expiryDate;
      if (!_isCurrentlyValid) {
        expiryDate = _expiryDateController.text;
      }

      final newCertification = Certification(
        name: _nameController.text,
        company: _issuingOrgController.text,
        companyLogo: _isCustomCompany ? null : _selectedCompanyLogo,
        companyId: _isCustomCompany ? null : _selectedCompanyId,
        issueDate: _issueDateController.text,
        expiryDate: expiryDate,
      );

      await provider.addCertification(newCertification);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Certification added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save certification: ${e.toString()}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Certification"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCertification,
            child:
                _isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: const CircleBorder(),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.verified,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Certification Name*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _issuingOrgController,
                    focusNode: _companyFocusNode,
                    onChanged: _onCompanyTextChanged,
                    decoration: const InputDecoration(
                      labelText: "Issuing Organization*",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),
              _buildCompanySelectionIndicator(),
              _buildCompanyResults(),
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _issueDateController,
                    decoration: const InputDecoration(
                      labelText: "Issue Date* (YYYY-MM)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, _issueDateController),
                    validator:
                        (value) => value?.isEmpty ?? true ? "Required" : null,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText:
                          "Expiry Date" +
                          (_isCurrentlyValid ? " (Present)" : " (YYYY-MM)"),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      suffixIcon:
                          _isCurrentlyValid
                              ? const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              )
                              : null,
                    ),
                    readOnly: true,
                    enabled: !_isCurrentlyValid,
                    onTap:
                        _isCurrentlyValid
                            ? null
                            : () => _selectDate(context, _expiryDateController),
                    validator: (value) {
                      if (!_isCurrentlyValid && (value?.isEmpty ?? true)) {
                        return "Required unless certificate does not expire";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Switch(
                        value: _isCurrentlyValid,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyValid = value;
                            if (value) {
                              _expiryDateController.clear();
                              _expiryDateController.text = "Present";
                            } else {
                              _expiryDateController.clear();
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const Text(
                        "This certificate does not expire",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCertification,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Save Certification",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
