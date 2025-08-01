import 'package:flutter/material.dart';
import '../services/contacts_service.dart';

class ContactCreateScreen extends StatefulWidget {
  const ContactCreateScreen({super.key});

  @override
  State<ContactCreateScreen> createState() => _ContactCreateScreenState();
}

class _ContactCreateScreenState extends State<ContactCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ContactsService _contactsService = ContactsService();

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accountIdController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _titleController.dispose();
    _departmentController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  Future<void> _createContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final contactData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'title': _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        'department': _departmentController.text.trim().isEmpty
            ? null
            : _departmentController.text.trim(),
        'street': _streetController.text.trim().isEmpty
            ? null
            : _streetController.text.trim(),
        'city': _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        'state': _stateController.text.trim().isEmpty
            ? null
            : _stateController.text.trim(),
        'postalCode': _postalCodeController.text.trim().isEmpty
            ? null
            : _postalCodeController.text.trim(),
        'country': _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'accountId': _accountIdController.text.trim().isEmpty
            ? null
            : _accountIdController.text.trim(),
      };

      // Remove null values to clean up the payload
      contactData.removeWhere((key, value) => value == null);

      final contact = await _contactsService.createContact(contactData);

      if (contact != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact ${contact.fullName} created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create contact'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating contact: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        validator:
            validator ??
            (required ? (value) => _validateRequired(value, label) : null),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Contact'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createContact,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                required: true,
                hint: 'Enter first name',
              ),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                required: true,
                hint: 'Enter last name',
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),

              // Professional Information Section
              _buildSectionHeader('Professional Information'),
              _buildTextField(
                controller: _titleController,
                label: 'Job Title',
                hint: 'Enter job title',
              ),
              _buildTextField(
                controller: _departmentController,
                label: 'Department',
                hint: 'Enter department',
              ),

              // Address Information Section
              _buildSectionHeader('Address Information'),
              _buildTextField(
                controller: _streetController,
                label: 'Street Address',
                hint: 'Enter street address',
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      hint: 'Enter city',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State',
                      hint: 'Enter state',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: 'Enter postal/zip code',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _countryController,
                      label: 'Country',
                      hint: 'Enter country',
                    ),
                  ),
                ],
              ),

              // Additional Information Section
              _buildSectionHeader('Additional Information'),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter additional notes or description',
                maxLines: 3,
              ),
              _buildTextField(
                controller: _accountIdController,
                label: 'Account ID',
                hint: 'Enter associated account ID (optional)',
              ),

              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createContact,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Creating Contact...'),
                          ],
                        )
                      : const Text(
                          'Create Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Help text
              Center(
                child: Text(
                  'Fields marked with * are required',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
