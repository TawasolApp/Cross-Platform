import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/experience.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

class AddExperiencePage extends StatefulWidget {
  const AddExperiencePage({super.key});

  @override
  State<AddExperiencePage> createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
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
    const Duration(
      milliseconds: 300,
    ), // Reduced from 500ms for quicker response
    initialValue: '',
  );
  bool _isSearching = false;
  bool _showCompanyResults = false;
  String? _selectedCompanyId;
  String? _selectedCompanyLogo;
  Company? _selectedCompany;
  bool _isCustomCompany = false; // Explicitly track if using custom company

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

  @override
  void initState() {
    super.initState();
    _companyController.addListener(_onCompanyTextChanged);
    _debouncer.values.listen(_searchCompanies);

    // Add focus listeners
    _titleFocusNode.addListener(_onFocusChange);
    _companyFocusNode.addListener(_onCompanyFocusChange);
    _locationFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);
  }

  // Special handler for company field focus
  void _onCompanyFocusChange() {
    // When focus gained, show results if text exists
    if (_companyFocusNode.hasFocus && _companyController.text.isNotEmpty) {
      _searchCompanies(_companyController.text);
      setState(() {
        _showCompanyResults = true;
      });
    }
    // When focus lost, hide results after a short delay (to allow clicking on results)
    else if (!_companyFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_companyFocusNode.hasFocus) {
          setState(() {
            _showCompanyResults = false;
          });
        }
      });
    }
  }

  // Handle focus changes to hide the company results dropdown
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
    // If text is changed, mark as potentially custom company
    if (_selectedCompany != null &&
        _companyController.text != _selectedCompany!.name) {
      _useCustomCompany();
    }

    if (_companyController.text.isNotEmpty) {
      // Trigger search with the current text
      _debouncer.value = _companyController.text;

      // Show results dropdown immediately if field has focus
      setState(() {
        _showCompanyResults = _companyFocusNode.hasFocus;
      });
    } else {
      setState(() {
        _showCompanyResults = false;
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
        _isCustomCompany = false; // Empty company name
      });
    }
  }

  // Add a dedicated method for using a custom company
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

      // Only show results if text still matches and field has focus
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

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected verified company: ${company.name}'),
        duration: const Duration(seconds: 2),
      ),
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _companyController.removeListener(_onCompanyTextChanged);

    // Dispose focus nodes
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

      final newExperience = Experience(
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
      );

      await provider.addExperience(newExperience);

      if (mounted) {
        // Show success snackbar before navigating back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Experience added successfully'),
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
          // Custom company option at the top for easier access
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _useCustomCompany();
                _showCompanyResults = false;
                FocusScope.of(context).unfocus();
                // Show confirmation
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

          // Company results
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Experience"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveExperience,
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
          // Hide keyboard when tapping on background
          FocusScope.of(context).unfocus();
        },
        // This ensures the gesture detector doesn't block taps on interactive elements
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Company Logo Placeholder
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
                                Icons.business,
                                size: 40,
                                color: Colors.blueGrey,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Job Title
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
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      decoration: const InputDecoration(
                        labelText: "Job Title*",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                  ),
                ),

                // Company Name with search
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
                          controller: _companyController,
                          focusNode: _companyFocusNode,
                          decoration: InputDecoration(
                            labelText: "Company*",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_companyController.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
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
                                    color: Colors.blueGrey,
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
                                  value?.isEmpty ?? true ? "Required" : null,
                        ),
                      ),
                    ),
                    _buildCompanyResults(),
                    _buildCompanySelectionIndicator(),
                  ],
                ),

                // Add margin after the company search block
                const SizedBox(height: 16),

                // Location
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
                      controller: _locationController,
                      focusNode: _locationFocusNode,
                      decoration: const InputDecoration(
                        labelText: "Location*",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                  ),
                ),

                // Employment Type
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blueGrey,
                      ),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),

                // Location Type
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blueGrey,
                      ),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),

                // Start Date
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
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: "Start Date* (YYYY-MM)",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _startDateController),
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                  ),
                ),

                // End Date and Currently Working
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
                      controller: _endDateController,
                      decoration: InputDecoration(
                        labelText:
                            "End Date" +
                            (_isCurrentlyWorking ? " (Present)" : " (YYYY-MM)"),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        suffixIcon:
                            _isCurrentlyWorking
                                ? const Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                      readOnly: true,
                      enabled: !_isCurrentlyWorking,
                      onTap:
                          () =>
                              _isCurrentlyWorking
                                  ? null
                                  : _selectDate(context, _endDateController),
                      validator: (value) {
                        if (!_isCurrentlyWorking && (value?.isEmpty ?? true)) {
                          return "Required unless currently working";
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
                          activeColor: Theme.of(context).primaryColor,
                        ),
                        const Text(
                          "I currently work here",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                // Description
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      decoration: const InputDecoration(
                        labelText: "Description*",
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                      ),
                      maxLines: 5,
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                  ),
                ),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveExperience,
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
                              "Save Experience",
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
      ),
    );
  }

  // Add this indicator below the company text field if a company has been selected
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
