import 'package:flutter/material.dart';
import '../services/leads_service.dart';
import '../models/api_models.dart';

class LeadCreateScreen extends StatefulWidget {
  const LeadCreateScreen({super.key});

  @override
  State<LeadCreateScreen> createState() => _LeadCreateScreenState();
}

class _LeadCreateScreenState extends State<LeadCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final LeadsService _leadsService = LeadsService();

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dropdown values
  LeadStatus _selectedStatus = LeadStatus.newLead;
  LeadSource _selectedLeadSource = LeadSource.web;
  LeadIndustry? _selectedIndustry;
  LeadRating? _selectedRating;

  bool _isLoading = false;


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createLead() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final leadData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'company': _companyController.text.trim().isEmpty
            ? null
            : _companyController.text.trim(),
        'title': _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        'status': _selectedStatus.value,
        'leadSource': _selectedLeadSource.value,
        'industry': _selectedIndustry?.value,
        'rating': _selectedRating?.value,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      };

      final createdLead = await _leadsService.createLead(leadData);

      if (mounted) {
        if (createdLead != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lead created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create lead. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating lead: $e'),
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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Lead'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createLead,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Information section
              Text(
                'Lead Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Title/Subject of Lead
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Lead Title *',
                  hintText: 'e.g., VP of Engineering - TechCorp Solutions',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lead title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Lead Description *',
                  hintText: 'Describe the lead opportunity, needs, interests, etc.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lead description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Contact Details section
              Text(
                'Contact Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),

              // Company
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 24),

              // Lead Classification section
              Text(
                'Lead Classification',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Status dropdown
              DropdownButtonFormField<LeadStatus>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items: LeadStatus.values.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status.value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Lead Source dropdown
              DropdownButtonFormField<LeadSource>(
                value: _selectedLeadSource,
                decoration: InputDecoration(
                  labelText: 'Lead Source',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items: LeadSource.values.map((source) {
                  return DropdownMenuItem(
                    value: source,
                    child: Text(source.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLeadSource = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Industry dropdown
              DropdownButtonFormField<LeadIndustry?>(
                value: _selectedIndustry,
                decoration: InputDecoration(
                  labelText: 'Industry',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items: [
                  const DropdownMenuItem<LeadIndustry?>(
                    value: null,
                    child: Text('Select Industry'),
                  ),
                  ...LeadIndustry.values.map((industry) {
                    return DropdownMenuItem(
                      value: industry,
                      child: Text(industry.value),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedIndustry = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Rating dropdown
              DropdownButtonFormField<LeadRating?>(
                value: _selectedRating,
                decoration: InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items: [
                  const DropdownMenuItem<LeadRating?>(
                    value: null,
                    child: Text('Select Rating'),
                  ),
                  ...LeadRating.values.map((rating) {
                    return DropdownMenuItem(value: rating, child: Text(rating.value));
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRating = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Create button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createLead,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Lead'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
