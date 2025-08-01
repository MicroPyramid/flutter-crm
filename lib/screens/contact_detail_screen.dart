import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/api_models.dart';
import '../services/contacts_service.dart';

class ContactDetailScreen extends StatefulWidget {
  final String contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final ContactsService _contactsService = ContactsService();

  Contact? _contact;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContactDetails();
  }

  Future<void> _loadContactDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final contact = await _contactsService.getContactById(widget.contactId);

      if (contact != null && mounted) {
        setState(() {
          _contact = contact;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Contact not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
    }
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String? value,
    IconData? icon,
    VoidCallback? onTap,
    bool copyable = false,
  }) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap:
                  onTap ??
                  (copyable ? () => _copyToClipboard(value, label) : null),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onTap != null || copyable
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  decoration: onTap != null || copyable
                      ? TextDecoration.underline
                      : null,
                ),
              ),
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () => _copyToClipboard(value, label),
              child: Icon(Icons.copy, size: 16, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(RelatedAccount relatedAccount) {
    final account = relatedAccount.account;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    account.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (relatedAccount.isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Primary',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(label: 'Role', value: relatedAccount.role),
            _buildInfoRow(label: 'Type', value: account.type),
            if (account.website != null)
              _buildInfoRow(
                label: 'Website',
                value: account.website,
                copyable: true,
              ),
            if (account.phone != null)
              _buildInfoRow(
                label: 'Phone',
                value: account.phone,
                copyable: true,
              ),
            if (relatedAccount.description != null &&
                relatedAccount.description!.isNotEmpty)
              _buildInfoRow(
                label: 'Description',
                value: relatedAccount.description,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Contact Details'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _contact == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Contact Details'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Failed to load contact',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadContactDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final contact = _contact!;

    return Scaffold(
      appBar: AppBar(
        title: Text(contact.fullName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit contact screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit contact feature coming soon'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _showDeleteConfirmation();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Contact', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadContactDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        contact.firstName.isNotEmpty
                            ? contact.firstName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      contact.fullName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (contact.title != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        contact.title!,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (contact.department != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        contact.department!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Quick Actions
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (contact.phone != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement phone call
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone call feature coming soon'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),
                    if (contact.phone != null && contact.email != null)
                      const SizedBox(width: 12),
                    if (contact.email != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement email
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email feature coming soon'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contact Information
              _buildInfoSection(
                title: 'Contact Information',
                icon: Icons.contact_page,
                children: [
                  _buildInfoRow(
                    label: 'Email',
                    value: contact.email,
                    icon: Icons.email,
                    copyable: true,
                  ),
                  _buildInfoRow(
                    label: 'Phone',
                    value: contact.phone,
                    icon: Icons.phone,
                    copyable: true,
                  ),
                ],
              ),

              // Address Information
              if (contact.fullAddress.isNotEmpty)
                _buildInfoSection(
                  title: 'Address',
                  icon: Icons.location_on,
                  children: [
                    _buildInfoRow(label: 'Street', value: contact.street),
                    _buildInfoRow(label: 'City', value: contact.city),
                    _buildInfoRow(label: 'State', value: contact.state),
                    _buildInfoRow(
                      label: 'Postal Code',
                      value: contact.postalCode,
                    ),
                    _buildInfoRow(label: 'Country', value: contact.country),
                    if (contact.fullAddress.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Full Address: ${contact.fullAddress}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _copyToClipboard(
                                contact.fullAddress,
                                'Address',
                              ),
                              child: Icon(
                                Icons.copy,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

              // Related Accounts
              if (contact.relatedAccounts != null &&
                  contact.relatedAccounts!.isNotEmpty)
                _buildInfoSection(
                  title:
                      'Related Accounts (${contact.relatedAccounts!.length})',
                  icon: Icons.business,
                  children: contact.relatedAccounts!
                      .map((account) => _buildAccountCard(account))
                      .toList(),
                ),

              // Description
              if (contact.description != null &&
                  contact.description!.isNotEmpty)
                _buildInfoSection(
                  title: 'Description',
                  icon: Icons.description,
                  children: [
                    Text(
                      contact.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

              // Owner and Organization
              _buildInfoSection(
                title: 'Ownership',
                icon: Icons.person,
                children: [
                  if (contact.owner != null)
                    _buildInfoRow(
                      label: 'Owner',
                      value:
                          '${contact.owner!.fullName} (${contact.owner!.email})',
                    ),
                  if (contact.organization != null)
                    _buildInfoRow(
                      label: 'Organization',
                      value: contact.organization!.name,
                    ),
                ],
              ),

              // Timestamps
              _buildInfoSection(
                title: 'Timeline',
                icon: Icons.access_time,
                children: [
                  _buildInfoRow(
                    label: 'Created',
                    value: _formatDate(contact.createdAt),
                  ),
                  _buildInfoRow(
                    label: 'Last Updated',
                    value: _formatDate(contact.updatedAt),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text(
            'Are you sure you want to delete ${_contact!.fullName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteContact();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteContact() async {
    final success = await _contactsService.deleteContact(_contact!.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_contact!.fullName} deleted successfully')),
      );
      Navigator.of(context).pop(true); // Return true to indicate deletion
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete contact')));
    }
  }
}
