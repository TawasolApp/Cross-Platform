import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

class EditExperiencePage extends StatefulWidget {
  final Experience? experience;

  const EditExperiencePage({super.key, this.experience});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Add focus nodes for each field
  final _titleFocusNode = FocusNode();
  final _companyFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  // Company search variables - reduce debounce time for faster response
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

  // Define dropdown options
  static const List<String> employmentTypes = [
    "Full-time",
    "Part-time",
    "Internship",
    "Freelance",
  ];

  static const List<String> locationTypes = ["On-site", "Remote", "Hybrid"];

  String _employmentType = "Full-time";
  String _locationType = "On-site";
  bool _isCurrentlyWorking = false;
  bool _isSaving = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeExperience();
    });

    _companyController.addListener(_onCompanyTextChanged);
    _debouncer.values.listen(_searchCompanies);

    // Add focus listeners
    _titleFocusNode.addListener(_onFocusChange);
    _companyFocusNode.addListener(_onCompanyFocusChange);
    _locationFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);

    _companyFocusNode.addListener(() {
      if (_companyFocusNode.hasFocus && widget.experience != null) {
        setState(() {
          _isCustomCompany =
              true; // Force custom state when focusing on existing field
        });
      }
    });
  }

  void _initializeExperience() {
    if (widget.experience != null && !_initialDataLoaded) {
      final exp = widget.experience!;
      _titleController.text = exp.title;
      _companyController.text = exp.company;
      _locationController.text = exp.location ?? '';
      _startDateController.text = exp.startDate;
      _isCurrentlyWorking = exp.endDate == null;
      _endDateController.text =
          exp.endDate ?? (_isCurrentlyWorking ? 'Present' : '');
      _descriptionController.text = exp.description ?? '';

      // Set company details
      _selectedCompanyId = exp.companyId;
      _selectedCompanyLogo = exp.companyLogo;
      _isCustomCompany = exp.companyId == null;

      // Clear selection if it's a custom company
      if (_isCustomCompany) {
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
      }

      // If there's a company ID but we don't have company details, try to fetch them
      if (exp.companyId != null && !_isCustomCompany) {
        final companyProvider = Provider.of<CompanyListProvider>(
          context,
          listen: false,
        );
        companyProvider.resetProvider();
        companyProvider.fetchCompanies(exp.company).then((_) {
          if (companyProvider.companies.isNotEmpty) {
            final matchedCompany = companyProvider.companies.firstWhere(
              (company) => company.companyId == exp.companyId,
              orElse: () => companyProvider.companies.first,
            );

            if (mounted) {
              setState(() {
                _selectedCompany = matchedCompany;
                _isCustomCompany = false;
              });
            }
          }
        });
      }

      // Convert stored values to match our dropdown options format
      final storedEmploymentType = exp.employmentType.replaceAll('_', '-');
      _employmentType = employmentTypes.firstWhere(
        (type) => type.toLowerCase() == storedEmploymentType.toLowerCase(),
        orElse: () => "Full-time",
      );

      if (exp.locationType != null) {
        final storedLocationType = exp.locationType!.replaceAll('_', '-');
        _locationType = locationTypes.firstWhere(
          (type) => type.toLowerCase() == storedLocationType.toLowerCase(),
          orElse: () => "On-site",
        );
      }

      // NEW: Force custom state after initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _companyController.text.isNotEmpty) {
          setState(() {
            _isCustomCompany = true;
          });
        }
      });

      _initialDataLoaded = true;
    }
  }

  void _onCompanyFocusChange() {
    if (_companyFocusNode.hasFocus && _companyController.text.isNotEmpty) {
      _searchCompanies(_companyController.text);
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
    if (_companyController.text.isNotEmpty &&
        (_selectedCompany == null ||
            _companyController.text != _selectedCompany!.name)) {
      setState(() {
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
        _isCustomCompany = true;
      });
    }

    // Clear selection if text changes and doesn't match selected company
    if (_selectedCompany != null &&
        _companyController.text != _selectedCompany!.name) {
      setState(() {
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
        _isCustomCompany = true;
      });
    }

    // Always mark as custom if there's text but no selected company
    if (_companyController.text.isNotEmpty && _selectedCompany == null) {
      setState(() {
        _isCustomCompany = true;
      });
    }

    if (_companyController.text.isNotEmpty) {
      _debouncer.value = _companyController.text;
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
          _companyController.text == query &&
          _companyFocusNode.hasFocus) {
        setState(() {
          _showCompanyResults = true;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching companies: ${error.toString()}'),
            duration: Duration(seconds: 2),
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
      _companyController.text = company.name;
      _showCompanyResults = false;
      _isCustomCompany = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected verified company: ${company.name}'),
        duration: Duration(seconds: 2),
      ),
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _companyController.removeListener(_onCompanyTextChanged);

    _titleFocusNode.removeListener(_onFocusChange);
    _companyFocusNode.removeListener(_onCompanyFocusChange);
    _locationFocusNode.removeListener(_onFocusChange);
    _descriptionFocusNode.removeListener(_onFocusChange);

    _titleFocusNode.dispose();
    _companyFocusNode.dispose();
    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExperience() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Make sure to set endDate to null when currently working
      String? endDate;
      if (!_isCurrentlyWorking) {
        endDate = _endDateController.text;
      }

      final experience = Experience(
        title: _titleController.text,
        company: _companyController.text,
        location:
            _locationController.text.isNotEmpty
                ? _locationController.text
                : null,
        startDate: _startDateController.text,
        endDate: endDate, // Use the correctly processed endDate
        description:
            _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
        employmentType: _employmentType.toLowerCase().replaceAll('-', '_'),
        locationType: _locationType.toLowerCase().replaceAll('-', '_'),
        companyLogo: _isCustomCompany ? null : _selectedCompanyLogo,
        companyId: _isCustomCompany ? null : _selectedCompanyId,
        workExperienceId: widget.experience?.workExperienceId,
      );

      if (widget.experience != null) {
        await provider.updateExperience(widget.experience!, experience);
      } else {
        await provider.addExperience(experience);
      }

      if (mounted) {
        // Show success snackbar before navigating back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Experience updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save experience: ${e.toString()}'),
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
                      'Using "${_companyController.text}" as custom company',
                    ),
                    duration: Duration(seconds: 2),
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
                        'Use "${_companyController.text}" as custom company',
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
              child: Center(child: Text("No companies found")),
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
                                  child: Icon(Icons.business),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.experience != null ? "Edit Experience" : "Add Experience",
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
            onPressed: _isSaving ? null : _saveExperience,
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
              // Company Logo Section
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
                                  Icons.business,
                                  size: 55,
                                  color: Colors.grey[400],
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_companyController.text.isNotEmpty)
                      Text(
                        _companyController.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_titleController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _titleController.text,
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

              // Job Information Section
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
                          "Job Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Job Title Field
                      _buildTextField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        label: "Job Title",
                        icon: Icons.work_outline,
                        required: true,
                      ),

                      const SizedBox(height: 16),

                      // Company Field with Search
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _companyController,
                            focusNode: _companyFocusNode,
                            decoration: InputDecoration(
                              labelText: "Company *",
                              prefixIcon: Icon(
                                Icons.business_center_outlined,
                                color: Colors.grey[600],
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_companyController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _companyController.text = '';
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
                                      if (_companyController.text.isEmpty) {
                                        // If empty, show a hint
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Start typing to search for companies',
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
                                            _companyController.text,
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
                              if (_companyController.text.isNotEmpty) {
                                _searchCompanies(_companyController.text);
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

                      const SizedBox(height: 16),

                      // Location Field
                      _buildTextField(
                        controller: _locationController,
                        focusNode: _locationFocusNode,
                        label: "Location",
                        icon: Icons.location_on_outlined,
                        required: true,
                        hint: "City, Country",
                      ),
                    ],
                  ),
                ),
              ),

              // Employment Details Section
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
                          "Employment Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Employment Type Dropdown
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
                          child: DropdownButtonFormField<String>(
                            value: _employmentType,
                            items:
                                employmentTypes
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _employmentType = value);
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: "Employment Type*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blueGrey,
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ),
                      ),

                      // Location Type Dropdown
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
                          child: DropdownButtonFormField<String>(
                            value: _locationType,
                            items:
                                locationTypes
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _locationType = value);
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: "Location Type*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blueGrey,
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Employment Period Section
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
                          "Employment Period",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Start Date Field
                      TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: "Start Date *",
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
                        onTap: () => _selectDate(context, _startDateController),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? "This field is required"
                                    : null,
                      ),

                      const SizedBox(height: 16),

                      // End Date Field
                      TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText:
                              "End Date" +
                              (_isCurrentlyWorking ? " (Present)" : " *"),
                          hintText: _isCurrentlyWorking ? "Present" : "YYYY-MM",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                          ),
                          suffixIcon:
                              _isCurrentlyWorking
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
                        enabled: !_isCurrentlyWorking,
                        onTap:
                            () =>
                                _isCurrentlyWorking
                                    ? null
                                    : _selectDate(context, _endDateController),
                        validator: (value) {
                          if (!_isCurrentlyWorking &&
                              (value?.isEmpty ?? true)) {
                            return "Required unless currently working";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Currently Working Switch
                      SwitchListTile(
                        title: const Text(
                          "I currently work here",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: _isCurrentlyWorking,
                        onChanged: (value) {
                          setState(() {
                            _isCurrentlyWorking = value;
                            // Clear end date when "currently working" is selected
                            if (value) {
                              _endDateController.clear();
                              // Set display text to "Present" - will be cleared before saving
                              _endDateController.text = "Present";
                            } else {
                              _endDateController.clear();
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

              // Description Section
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
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        decoration: InputDecoration(
                          hintText:
                              "Describe your responsibilities, achievements, and experience in this role",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
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
                        maxLines: 6,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? "This field is required"
                                    : null,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveExperience,
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
                            "Save Experience",
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
            const Icon(Icons.business, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Using verified company: ${_selectedCompany!.name}',
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
    } else if (_companyController.text.isNotEmpty) {
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
                    ? 'Using custom company name'
                    : 'Type to search for verified companies',
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
}
