import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

class EditCertificationPage extends StatefulWidget {
  final Certification? certification;

  const EditCertificationPage({super.key, this.certification});

  @override
  State<EditCertificationPage> createState() => _EditCertificationPageState();
}

class _EditCertificationPageState extends State<EditCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuingOrgController = TextEditingController();
  final _issueDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  // Company search variables
  final _debouncer = Debouncer<String>(
    const Duration(milliseconds: 300),
    initialValue: '',
  );
  bool _isSearching = false;
  bool _showCompanyResults = false;
  String? _selectedCompanyId;
  String? _selectedCompanyLogo;
  Company? _selectedCompany;
  bool _isCustomCompany = false;

  // Focus node for company field
  final _companyFocusNode = FocusNode();

  bool _isCurrentlyValid = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _issuingOrgController.addListener(_onCompanyTextChanged);
    _debouncer.values.listen(_searchCompanies);

    _companyFocusNode.addListener(_onCompanyFocusChange);

    // Initialize with existing certification if editing
    if (widget.certification != null) {
      final cert = widget.certification!;
      _nameController.text = cert.name;
      _issuingOrgController.text = cert.company;
      _issueDateController.text = cert.issueDate;
      _isCurrentlyValid = cert.expiryDate == null;
      _expiryDateController.text =
          cert.expiryDate ?? (_isCurrentlyValid ? 'Present' : '');

      // Set company details
      _selectedCompanyId = cert.companyId;
      _selectedCompanyLogo = cert.companyLogo;
      _isCustomCompany = cert.companyId == null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingOrgController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _companyFocusNode.dispose();
    _issuingOrgController.removeListener(_onCompanyTextChanged);
    super.dispose();
  }

  void _onCompanyFocusChange() {
    if (_companyFocusNode.hasFocus && _issuingOrgController.text.isNotEmpty) {
      _searchCompanies(_issuingOrgController.text);
      setState(() {
        _showCompanyResults = true;
      });
    } else if (!_companyFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_companyFocusNode.hasFocus) {
          setState(() {
            _showCompanyResults = false;
          });
        }
      });
    }
  }

  void _onCompanyTextChanged() {
    if (_selectedCompany != null &&
        _issuingOrgController.text != _selectedCompany!.name) {
      _useCustomCompany();
    }

    if (_issuingOrgController.text.isNotEmpty) {
      _debouncer.value = _issuingOrgController.text;
      setState(() {
        _showCompanyResults = _companyFocusNode.hasFocus;
      });
    } else {
      setState(() {
        _showCompanyResults = false;
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
        _isCustomCompany = false;
      });
    }
  }

  void _useCustomCompany() {
    setState(() {
      _selectedCompany = null;
      _selectedCompanyId = null;
      _selectedCompanyLogo = null;
      _isCustomCompany = true;
    });
  }

  Future<void> _searchCompanies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _showCompanyResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final companyProvider = Provider.of<CompanyListProvider>(
        context,
        listen: false,
      );
      companyProvider.resetProvider();
      await companyProvider.fetchCompanies(query);

      if (mounted &&
          _issuingOrgController.text == query &&
          _companyFocusNode.hasFocus) {
        setState(() {
          _showCompanyResults = true;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching organizations: ${error.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _selectCompany(Company company) {
    setState(() {
      _selectedCompany = company;
      _selectedCompanyId = company.companyId;
      _selectedCompanyLogo = company.logo;
      _issuingOrgController.text = company.name;
      _showCompanyResults = false;
      _isCustomCompany = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected verified organization: ${company.name}'),
        duration: const Duration(seconds: 2),
      ),
    );

    FocusScope.of(context).unfocus();
  }

  Future<void> _saveCertification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Make sure to set expiryDate to null when certification doesn't expire
      String? expiryDate;
      if (!_isCurrentlyValid) {
        expiryDate = _expiryDateController.text;
      }

      final certification = Certification(
        certificationId: widget.certification?.certificationId,
        name: _nameController.text,
        company: _issuingOrgController.text,
        companyLogo: _isCustomCompany ? null : _selectedCompanyLogo,
        companyId: _isCustomCompany ? null : _selectedCompanyId,
        issueDate: _issueDateController.text,
        expiryDate: expiryDate, // Use the correctly processed expiryDate
      );

      if (widget.certification != null) {
        await provider.updateCertification(
          widget.certification!,
          certification,
        );
      } else {
        await provider.addCertification(certification);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Certification saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save certification: ${e.toString()}'),
            duration: const Duration(seconds: 2),
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

  Widget _buildCompanyResults() {
    final companyProvider = Provider.of<CompanyListProvider>(context);

    if (!_showCompanyResults) {
      return const SizedBox.shrink();
    }

    if (_isSearching) {
      return Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _useCustomCompany();
                _showCompanyResults = false;
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Using "${_issuingOrgController.text}" as custom organization',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: _isCustomCompany ? Colors.blue.withOpacity(0.1) : null,
                child: Row(
                  children: [
                    Icon(
                      _isCustomCompany
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: _isCustomCompany ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Use "${_issuingOrgController.text}" as custom organization',
                        style: TextStyle(
                          color:
                              _isCustomCompany ? Colors.blue : Colors.black87,
                          fontWeight:
                              _isCustomCompany
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          if (companyProvider.companies.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text("No organizations found")),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: companyProvider.companies.length,
                separatorBuilder:
                    (context, index) => const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final company = companyProvider.companies[index];
                  final isSelected =
                      _selectedCompany?.companyId == company.companyId;
                  return Material(
                    color:
                        isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectCompany(company),
                      child: ListTile(
                        leading:
                            company.logo != null && company.logo!.isNotEmpty
                                ? CircleAvatar(
                                  backgroundImage: NetworkImage(company.logo!),
                                )
                                : const CircleAvatar(
                                  child: Icon(Icons.verified),
                                ),
                        title: Text(company.name),
                        subtitle: Text(company.industry),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompanySelectionIndicator() {
    if (_selectedCompany != null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 0,
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            const Icon(Icons.verified, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Using verified organization: ${_selectedCompany!.name}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_issuingOrgController.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 0,
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            Icon(
              _isCustomCompany
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
              size: 16,
              color: _isCustomCompany ? Colors.blue : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isCustomCompany
                    ? 'Using custom organization name'
                    : 'Type to search for verified organizations',
                style: TextStyle(
                  fontSize: 12,
                  color: _isCustomCompany ? Colors.blue : Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.certification != null
              ? "Edit Certification"
              : "Add Certification",
        ),
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
      body: GestureDetector(
        onTap: () {
          // Close dropdown when tapping elsewhere
          if (_showCompanyResults) {
            setState(() {
              _showCompanyResults = false;
            });
          }
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Organization Logo Placeholder
                Card(
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _selectedCompanyLogo != null
                              ? NetworkImage(_selectedCompanyLogo!)
                              : null,
                      child:
                          _selectedCompanyLogo == null
                              ? const Icon(
                                Icons.verified,
                                size: 40,
                                color: Colors.blueGrey,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Certification Name
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

                // Issuing Organization with search
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape:
                          _showCompanyResults
                              ? const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              )
                              : RoundedRectangleBorder(
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
                          decoration: InputDecoration(
                            labelText: "Issuing Organization*",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_issuingOrgController.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _issuingOrgController.text = '';
                                        _selectedCompany = null;
                                        _selectedCompanyId = null;
                                        _selectedCompanyLogo = null;
                                        _isCustomCompany = false;
                                      });
                                    },
                                  ),
                                IconButton(
                                  icon: Icon(
                                    _showCompanyResults
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {
                                    // Don't show empty results
                                    if (_issuingOrgController.text.isEmpty)
                                      return;

                                    setState(() {
                                      _showCompanyResults =
                                          !_showCompanyResults;
                                      if (_showCompanyResults) {
                                        _searchCompanies(
                                          _issuingOrgController.text,
                                        );
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Only show results if there's text to search
                            if (_issuingOrgController.text.isNotEmpty) {
                              setState(() {
                                _showCompanyResults = true;
                              });
                            }
                          },
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                        ),
                      ),
                    ),
                    _buildCompanyResults(),
                    _buildCompanySelectionIndicator(),
                  ],
                ),

                const SizedBox(height: 16),

                // Issue Date
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

                // Expiry Date - Updated to match education end date pattern
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
                            (_isCurrentlyValid ? " (No Expiry)" : " (YYYY-MM)"),
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
                          () =>
                              _isCurrentlyValid
                                  ? null
                                  : _selectDate(context, _expiryDateController),
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
                              // Update expiry date field when switch changes
                              if (value) {
                                _expiryDateController.text = "No Expiry";
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

                // Save Button
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
                            : Text(
                              widget.certification != null
                                  ? "Update Certification"
                                  : "Save Certification",
                              style: const TextStyle(
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
      ),
    );
  }
}
