import 'package:flutter/material.dart';

class JobFilterScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const JobFilterScreen({super.key, this.initialFilters});

  @override
  State<JobFilterScreen> createState() => _JobFilterScreenState();
}

class _JobFilterScreenState extends State<JobFilterScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters ?? {};

    _locationController.text = filters['location'] ?? '';
    _industryController.text = filters['industry'] ?? '';
    _experienceController.text = filters['experienceLevel'] ?? '';
    _companyController.text = filters['company'] ?? '';
    _minSalaryController.text = filters['minSalary']?.toString() ?? '';
    _maxSalaryController.text = filters['maxSalary']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Filter Jobs'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          key: const ValueKey('company_add_admin_back_button'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilterInput("Location", _locationController),
            _buildFilterInput("Industry", _industryController),

            // 🔽 Dropdown for Experience Level
            DropdownButtonFormField<String>(
              key: const ValueKey('job_search_experience_level_dropdown'),
              value:
                  _experienceController.text.isEmpty
                      ? null
                      : _experienceController.text,
              onChanged: (value) {
                setState(() {
                  _experienceController.text = value ?? '';
                });
              },
              items:
                  [
                    'Internship',
                    'Entry Level',
                    'Junior',
                    'Mid Level',
                    'Senior',
                    'Lead',
                    'Manager',
                    'Director',
                    'Executive',
                  ].map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
              decoration: InputDecoration(
                labelText: 'Experience Level',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildFilterInput("Company", _companyController),

            Row(
              children: [
                // Min Salary Box
                Expanded(
                  child: _buildFilterInput(
                    "\$ Min Salary ",
                    _minSalaryController,
                  ),
                ),

                // Arrow ➡️
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ),

                // Max Salary Box
                Expanded(
                  child: _buildFilterInput(
                    "\$ Max Salary",
                    _maxSalaryController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🧹 Clear Button
            TextButton(
              onPressed: () {
                setState(() {
                  _locationController.clear();
                  _industryController.clear();
                  _experienceController.text = ''; // Reset the dropdown text
                  _companyController.clear();
                  _minSalaryController.clear();
                  _maxSalaryController.clear();
                });
              },
              child: const Text('Clear All'),
            ),

            const SizedBox(height: 8),

            // ✅ Apply Button
            ElevatedButton(
              key: const ValueKey('job_search_apply_button'),
              onPressed: () {
                Navigator.pop(context, {
                  'location': _locationController.text.trim(),
                  'industry': _industryController.text.trim(),
                  'experienceLevel': _experienceController.text.trim(),
                  'company': _companyController.text.trim(),
                  'minSalary': double.tryParse(
                    _minSalaryController.text.trim(),
                  ),
                  'maxSalary': double.tryParse(
                    _maxSalaryController.text.trim(),
                  ),
                });
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterInput(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        key: const ValueKey('company_add_admin_field'),
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
