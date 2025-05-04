import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/certification.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

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
  final _nameFocusNode = FocusNode();

  bool _isCurrentlyValid = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _issuingOrgController.addListener(_onCompanyTextChanged);
    _debouncer.values.listen(_searchCompanies);

    _companyFocusNode.addListener(_onCompanyFocusChange);
    _nameFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingOrgController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();

    _companyFocusNode.removeListener(_onCompanyFocusChange);
    _nameFocusNode.removeListener(_onFocusChange);

    _companyFocusNode.dispose();
    _nameFocusNode.dispose();

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

  void _onFocusChange() {
    if (!_companyFocusNode.hasFocus && _showCompanyResults) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
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
        name: _nameController.text,
        company: _issuingOrgController.text,
        companyLogo: _isCustomCompany ? null : _selectedCompanyLogo,
        companyId: _isCustomCompany ? null : _selectedCompanyId,
        issueDate: _issueDateController.text,
        expiryDate: expiryDate, // Use the correctly processed expiryDate
      );

      await provider.addCertification(certification);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Certification added successfully'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    String? hint,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: required ? "$label *" : label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
      validator:
          required
              ? (value) =>
                  value?.trim().isEmpty ?? true
                      ? "This field is required"
                      : null
              : null,
      style: const TextStyle(fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Certification",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveCertification,
            icon:
                _isSaving
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: theme.primaryColor,
                      ),
                    )
                    : Icon(Icons.check, color: theme.primaryColor),
            label: Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _showCompanyResults = false;
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // Organization Logo Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            _selectedCompanyLogo != null
                                ? NetworkImage(_selectedCompanyLogo!)
                                : null,
                        child:
                            _selectedCompanyLogo == null
                                ? Icon(
                                  Icons.verified,
                                  size: 55,
                                  color: Colors.grey[400],
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_nameController.text.isNotEmpty)
                      Text(
                        _nameController.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (_issuingOrgController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _issuingOrgController.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Certification Information Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          "Certification Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Certification Name
                      _buildTextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        label: "Certification Name",
                        icon: Icons.card_membership,
                        required: true,
                      ),

                      const SizedBox(height: 16),

                      // Issuing Organization Field with Search
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _issuingOrgController,
                            focusNode: _companyFocusNode,
                            decoration: InputDecoration(
                              labelText: "Issuing Organization *",
                              prefixIcon: Icon(
                                Icons.business,
                                color: Colors.grey[600],
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_issuingOrgController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _issuingOrgController.text = '';
                                          _selectedCompany = null;
                                          _selectedCompanyId = null;
                                          _selectedCompanyLogo = null;
                                          _isCustomCompany = false;
                                          _showCompanyResults = false;
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      _showCompanyResults
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      if (_issuingOrgController.text.isEmpty) {
                                        // If empty, show a hint
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Start typing to search for organizations',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        _showCompanyResults =
                                            !_showCompanyResults;
                                        if (_showCompanyResults) {
                                          // Re-trigger search when manually showing dropdown
                                          _searchCompanies(
                                            _issuingOrgController.text,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.primaryColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                            onTap: () {
                              // Only show results if there's text to search
                              if (_issuingOrgController.text.isNotEmpty) {
                                _searchCompanies(_issuingOrgController.text);
                                setState(() {
                                  _showCompanyResults = true;
                                });
                              }
                            },
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true
                                        ? "This field is required"
                                        : null,
                          ),
                          if (_showCompanyResults) _buildCompanyResults(),
                          _buildCompanySelectionIndicator(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Certification Duration Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          "Certification Duration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Issue Date Field
                      TextFormField(
                        controller: _issueDateController,
                        decoration: InputDecoration(
                          labelText: "Issue Date *",
                          hintText: "YYYY-MM",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _issueDateController),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? "This field is required"
                                    : null,
                      ),

                      const SizedBox(height: 16),

                      // Expiry Date Field
                      TextFormField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                          labelText:
                              "Expiry Date" +
                              (_isCurrentlyValid ? " (No Expiry)" : " *"),
                          hintText: _isCurrentlyValid ? "No Expiry" : "YYYY-MM",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                          ),
                          suffixIcon:
                              _isCurrentlyValid
                                  ? const Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  )
                                  : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        readOnly: true,
                        enabled: !_isCurrentlyValid,
                        onTap:
                            () =>
                                _isCurrentlyValid
                                    ? null
                                    : _selectDate(
                                      context,
                                      _expiryDateController,
                                    ),
                        validator: (value) {
                          if (!_isCurrentlyValid && (value?.isEmpty ?? true)) {
                            return "Required unless certificate does not expire";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // No Expiry Switch
                      SwitchListTile(
                        title: const Text(
                          "This certificate does not expire",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: _isCurrentlyValid,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyValid = value;
                            // Clear expiry date when "no expiry" is selected
                            if (value) {
                              _expiryDateController.clear();
                              // Set display text for user clarity - will be cleared before saving
                              _expiryDateController.text = "No Expiry";
                            } else {
                              _expiryDateController.clear();
                            }
                          });
                        },
                        activeColor: theme.primaryColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveCertification,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child:
                      _isSaving
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Saving...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : const Text(
                            "Save Certification",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
