import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

class AddEducationPage extends StatefulWidget {
  const AddEducationPage({super.key});

  @override
  State<AddEducationPage> createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _gradeController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Add focus nodes for each field
  final _schoolFocusNode = FocusNode();
  final _fieldFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _gradeFocusNode = FocusNode();

  // School search variables
  final _debouncer = Debouncer<String>(
    const Duration(milliseconds: 300), // Reduced for faster response
    initialValue: '',
  );
  bool _isSearching = false;
  bool _showCompanyResults = false;
  String? _selectedCompanyId;
  String? _selectedCompanyLogo;
  Company? _selectedCompany;
  bool _isCustomSchool = false; // Track if using custom school

  // Define dropdown options
  static const List<String> degreeTypes = [
    "High School",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctorate",
    "Associate Degree",
    "Professional Certificate",
  ];

  String _degreeType = "Bachelor's Degree";
  bool _isCurrentlyStudying = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _schoolController.addListener(_onSchoolTextChanged);
    _debouncer.values.listen(_searchCompanies);

    // Add focus listeners
    _schoolFocusNode.addListener(_onSchoolFocusChange);
    _fieldFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);
    _gradeFocusNode.addListener(_onFocusChange);
  }

  // Special handler for school field focus
  void _onSchoolFocusChange() {
    if (_schoolFocusNode.hasFocus && _schoolController.text.isNotEmpty) {
      _searchCompanies(_schoolController.text);
      setState(() {
        _showCompanyResults = true;
      });
    } else if (!_schoolFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_schoolFocusNode.hasFocus) {
          setState(() {
            _showCompanyResults = false;
          });
        }
      });
    }
  }

  // Handle focus changes to hide the company results dropdown
  void _onFocusChange() {
    if (!_schoolFocusNode.hasFocus && _showCompanyResults) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showCompanyResults = false;
          });
        }
      });
    }
  }

  void _onSchoolTextChanged() {
    // If text is changed, mark as potentially custom school
    if (_selectedCompany != null &&
        _schoolController.text != _selectedCompany!.name) {
      _useCustomSchool();
    }

    if (_schoolController.text.isNotEmpty) {
      // Trigger search with the current text
      _debouncer.value = _schoolController.text;

      // Show results dropdown immediately if field has focus
      setState(() {
        _showCompanyResults = _schoolFocusNode.hasFocus;
      });
    } else {
      setState(() {
        _showCompanyResults = false;
        _selectedCompany = null;
        _selectedCompanyId = null;
        _selectedCompanyLogo = null;
        _isCustomSchool = false;
      });
    }
  }

  // Add a dedicated method for using a custom school
  void _useCustomSchool() {
    setState(() {
      _selectedCompany = null;
      _selectedCompanyId = null;
      _selectedCompanyLogo = null;
      _isCustomSchool = true;
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
          _schoolController.text == query &&
          _schoolFocusNode.hasFocus) {
        setState(() {
          _showCompanyResults = true;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching institutions: ${error.toString()}'),
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
      _schoolController.text = company.name;
      _showCompanyResults = false;
      _isCustomSchool = false;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected verified institution: ${company.name}'),
        duration: const Duration(seconds: 2),
      ),
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _schoolController.removeListener(_onSchoolTextChanged);

    // Dispose focus nodes
    _schoolFocusNode.removeListener(_onSchoolFocusChange);
    _fieldFocusNode.removeListener(_onFocusChange);
    _descriptionFocusNode.removeListener(_onFocusChange);
    _gradeFocusNode.removeListener(_onFocusChange);

    _schoolFocusNode.dispose();
    _fieldFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _gradeFocusNode.dispose();

    _schoolController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _gradeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEducation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Make sure to set endDate to null when currently studying
      String? endDate;
      if (!_isCurrentlyStudying) {
        endDate = _endDateController.text;
      }

      final newEducation = Education(
        school: _schoolController.text,
        companyLogo: _isCustomSchool ? null : _selectedCompanyLogo,
        companyId: _isCustomSchool ? null : _selectedCompanyId,
        degree: _degreeType,
        field: _fieldController.text,
        startDate: _startDateController.text,
        endDate: endDate,
        grade: _gradeController.text,
        description: _descriptionController.text,
      );

      await provider.addEducation(newEducation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Education added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save education: ${e.toString()}'),
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
          // Custom school option at the top for easier access
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _useCustomSchool();
                _showCompanyResults = false;
                FocusScope.of(context).unfocus();
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Using "${_schoolController.text}" as custom school',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: _isCustomSchool ? Colors.blue.withOpacity(0.1) : null,
                child: Row(
                  children: [
                    Icon(
                      _isCustomSchool
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: _isCustomSchool ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Use "${_schoolController.text}" as custom school',
                        style: TextStyle(
                          color: _isCustomSchool ? Colors.blue : Colors.black87,
                          fontWeight:
                              _isCustomSchool
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
              child: Center(child: Text("No institutions found")),
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
                                : const CircleAvatar(child: Icon(Icons.school)),
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

  // Add this indicator below the school text field if a company has been selected
  Widget _buildSchoolSelectionIndicator() {
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
            const Icon(Icons.school, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Using verified institution: ${_selectedCompany!.name}',
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
    } else if (_schoolController.text.isNotEmpty) {
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
              _isCustomSchool ? Icons.check_circle_outline : Icons.info_outline,
              size: 16,
              color: _isCustomSchool ? Colors.blue : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isCustomSchool
                    ? 'Using custom school name'
                    : 'Type to search for verified institutions',
                style: TextStyle(
                  fontSize: 12,
                  color: _isCustomSchool ? Colors.blue : Colors.orange,
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
        title: const Text("Add Education"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveEducation,
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
          // Close company dropdown when tapping anywhere else
          if (_showCompanyResults) {
            setState(() {
              _showCompanyResults = false;
            });
          }
          // Hide keyboard when tapping on background
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // School Logo Placeholder
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
                                Icons.school,
                                size: 40,
                                color: Colors.blueGrey,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // School Name with search
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
                          controller: _schoolController,
                          focusNode: _schoolFocusNode,
                          decoration: InputDecoration(
                            labelText: "School*",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_schoolController.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _schoolController.text = '';
                                        _selectedCompany = null;
                                        _selectedCompanyId = null;
                                        _selectedCompanyLogo = null;
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
                                    if (_schoolController.text.isEmpty) return;

                                    setState(() {
                                      _showCompanyResults =
                                          !_showCompanyResults;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Only show results if there's text to search
                            if (_schoolController.text.isNotEmpty) {
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
                    _buildSchoolSelectionIndicator(),
                  ],
                ),

                // Add margin after the school search block
                const SizedBox(height: 16),

                // Degree Type
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
                      value: _degreeType,
                      items:
                          degreeTypes
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _degreeType = value);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "Degree*",
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

                // Field of Study
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
                      controller: _fieldController,
                      focusNode: _fieldFocusNode,
                      decoration: const InputDecoration(
                        labelText: "Field of Study*",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
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

                // End Date and Currently Studying
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
                            (_isCurrentlyStudying
                                ? " (Present)"
                                : " (YYYY-MM)"),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        suffixIcon:
                            _isCurrentlyStudying
                                ? const Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                      readOnly: true,
                      enabled: !_isCurrentlyStudying,
                      onTap:
                          () =>
                              _isCurrentlyStudying
                                  ? null
                                  : _selectDate(context, _endDateController),
                      validator: (value) {
                        if (!_isCurrentlyStudying && (value?.isEmpty ?? true)) {
                          return "Required unless currently studying";
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
                          value: _isCurrentlyStudying,
                          onChanged: (value) {
                            setState(() {
                              _isCurrentlyStudying = value;
                              // Update end date field when switch changes
                              if (value) {
                                _endDateController.clear();
                                _endDateController.text =
                                    "Present"; // Show "Present" in the UI
                              } else {
                                _endDateController.clear();
                              }
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                        const Text(
                          "I currently study here",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grade
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
                      controller: _gradeController,
                      focusNode: _gradeFocusNode,
                      decoration: const InputDecoration(
                        labelText: "Grade*",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      validator:
                          (value) => value?.isEmpty ?? true ? "Required" : null,
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
                    onPressed: _isSaving ? null : _saveEducation,
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
                              "Save Education",
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
}
