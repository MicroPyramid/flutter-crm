import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({super.key});

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  final AuthService _authService = AuthService();
  List<Organization>? _organizations;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // First try to use cached organizations
      if (_authService.organizations != null &&
          _authService.organizations!.isNotEmpty) {
        setState(() {
          _organizations = _authService.organizations;
          _isLoading = false;
        });

        // Fetch fresh data in background
        _authService.fetchOrganizations();
        return;
      }

      // If no cached data, fetch from API
      final success = await _authService.fetchOrganizations();
      if (success && mounted) {
        setState(() {
          _organizations = _authService.organizations;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load organizations'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading organizations: $e'),
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

  Future<void> _selectCompany(Organization organization) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.selectOrganization(organization);

      debugPrint('Organization selected: ${organization.name}');

      // Navigate to dashboard - let dashboard handle its own data loading
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting company: $e'),
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

  Widget _buildCompanyCard(Organization organization) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: organization.logo != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(organization.logo!),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (_, _) {},
                child: organization.logo == null
                    ? Text(
                        organization.name.isNotEmpty
                            ? organization.name[0].toUpperCase()
                            : 'C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  organization.name.isNotEmpty
                      ? organization.name[0].toUpperCase()
                      : 'C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(
          organization.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role: ${organization.role}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            if (organization.industry != null)
              Text(
                organization.industry!,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _isLoading ? null : () => _selectCompany(organization),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Select Company'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final result = await navigator.pushNamed('/company-create');
              if (result == true && mounted) {
                // Refresh organizations from API after creating a new company
                final success = await _authService.refreshOrganizations();
                if (success) {
                  await _loadOrganizations();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Company created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Company created, but failed to refresh list',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            },
            tooltip: 'Create Company',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await _authService.logout();
              if (mounted) {
                navigator.pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // User info section
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (user?.profileImage != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user!.profileImage!),
                        )
                      else
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            user?.name.isNotEmpty == true
                                ? user!.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        user?.name ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Company selection section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose your company to continue:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Organizations list
                Expanded(
                  child: _organizations == null || _organizations!.isEmpty
                      ? const Center(
                          child: Text(
                            'No companies available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _organizations!.length,
                          itemBuilder: (context, index) {
                            return _buildCompanyCard(_organizations![index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
