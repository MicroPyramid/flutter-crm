import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/leads_service.dart';

class LeadsListScreen extends StatefulWidget {
  const LeadsListScreen({super.key});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  final LeadsService _leadsService = LeadsService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Lead> _leads = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  bool _isSearching = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;

  String? _selectedStatus;
  String? _selectedSource;
  String? _selectedRating;
  String? _selectedIndustry;
  bool? _selectedConverted;

  @override
  void initState() {
    super.initState();
    _loadLeads();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _hasMoreData && !_isSearching) {
        _loadMoreLeads();
      }
    }
  }

  Future<void> _loadLeads({bool isRefresh = false}) async {
    debugPrint('Loading leads - refresh: $isRefresh');
    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _hasMoreData = true;
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final response = await _leadsService.getLeads(
        page: _currentPage,
        status: _selectedStatus,
        leadSource: _selectedSource,
        rating: _selectedRating,
        industry: _selectedIndustry,
        converted: _selectedConverted,
        searchQuery: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      );

      if (response != null) {
        setState(() {
          if (isRefresh || _currentPage == 1) {
            _leads = response.leads;
          } else {
            _leads.addAll(response.leads);
          }
          _hasMoreData = response.pagination.hasNext;
          _isLoading = false;
          _hasError = false;
          _isSearching = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load leads';
          _isLoading = false;
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
        _isSearching = false;
      });
    }
  }

  Future<void> _loadMoreLeads() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;

    try {
      final response = await _leadsService.getLeads(
        page: _currentPage,
        status: _selectedStatus,
        leadSource: _selectedSource,
        rating: _selectedRating,
        industry: _selectedIndustry,
        converted: _selectedConverted,
        searchQuery: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      );

      if (response != null) {
        setState(() {
          _leads.addAll(response.leads);
          _hasMoreData = response.pagination.hasNext;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoadingMore = false;
          _currentPage--;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadLeads(isRefresh: true);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = true;
    });
    _loadLeads(isRefresh: true);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Leads'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Statuses')),
                  DropdownMenuItem(value: 'NEW', child: Text('New')),
                  DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                  DropdownMenuItem(value: 'CONTACTED', child: Text('Contacted')),
                  DropdownMenuItem(value: 'QUALIFIED', child: Text('Qualified')),
                  DropdownMenuItem(value: 'UNQUALIFIED', child: Text('Unqualified')),
                  DropdownMenuItem(value: 'CONVERTED', child: Text('Converted')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Lead Source',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Sources')),
                  DropdownMenuItem(value: 'WEB', child: Text('Web')),
                  DropdownMenuItem(value: 'PHONE_INQUIRY', child: Text('Phone Inquiry')),
                  DropdownMenuItem(value: 'PARTNER_REFERRAL', child: Text('Partner Referral')),
                  DropdownMenuItem(value: 'COLD_CALL', child: Text('Cold Call')),
                  DropdownMenuItem(value: 'TRADE_SHOW', child: Text('Trade Show')),
                  DropdownMenuItem(value: 'EMPLOYEE_REFERRAL', child: Text('Employee Referral')),
                  DropdownMenuItem(value: 'ADVERTISEMENT', child: Text('Advertisement')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRating,
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Ratings')),
                  DropdownMenuItem(value: 'Hot', child: Text('Hot')),
                  DropdownMenuItem(value: 'Warm', child: Text('Warm')),
                  DropdownMenuItem(value: 'Cold', child: Text('Cold')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRating = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Industries')),
                  DropdownMenuItem(value: 'Technology', child: Text('Technology')),
                  DropdownMenuItem(value: 'Healthcare', child: Text('Healthcare')),
                  DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                  DropdownMenuItem(value: 'Education', child: Text('Education')),
                  DropdownMenuItem(value: 'Manufacturing', child: Text('Manufacturing')),
                  DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                  DropdownMenuItem(value: 'Real Estate', child: Text('Real Estate')),
                  DropdownMenuItem(value: 'Consulting', child: Text('Consulting')),
                  DropdownMenuItem(value: 'Media', child: Text('Media')),
                  DropdownMenuItem(value: 'Transportation', child: Text('Transportation')),
                  DropdownMenuItem(value: 'Energy', child: Text('Energy')),
                  DropdownMenuItem(value: 'Government', child: Text('Government')),
                  DropdownMenuItem(value: 'Non-profit', child: Text('Non-profit')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedIndustry = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool?>(
                value: _selectedConverted,
                decoration: const InputDecoration(
                  labelText: 'Converted',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: false, child: Text('Not Converted')),
                  DropdownMenuItem(value: true, child: Text('Converted')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedConverted = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedSource = null;
                _selectedRating = null;
                _selectedIndustry = null;
                _selectedConverted = null;
              });
              Navigator.pop(context);
              _loadLeads(isRefresh: true);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadLeads(isRefresh: true);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search leads by name, email, or company...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
              ),
              onChanged: (_) => _onSearchChanged(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "leads_fab",
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/lead-create');
          if (result == true) {
            _loadLeads(isRefresh: true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _leads.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_hasError && _leads.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Something went wrong',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadLeads(isRefresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_leads.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No leads found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first lead to get started',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _leads.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _leads.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final lead = _leads[index];
        return _buildLeadCard(lead);
      },
    );
  }

  Widget _buildLeadCard(Lead lead) {
    Color statusColor = _getStatusColor(lead.status);
    Color ratingColor = _getRatingColor(lead.rating);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: statusColor, width: 3),
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            lead.firstName.isNotEmpty ? lead.firstName[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                lead.title ?? 'Untitled Lead',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            if (lead.rating != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ratingColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ratingColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  lead.rating!,
                  style: TextStyle(
                    color: ratingColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lead.description != null) ...[
              const SizedBox(height: 4),
              Text(
                lead.description!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (lead.company != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.business_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lead.company!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusDisplayName(lead.status),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (lead.owner != null) ...[
              const SizedBox(height: 4),
              Text(
                'Owner: ${lead.owner!.fullName}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showLeadOptions(context, lead);
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/lead-detail', arguments: lead.id);
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return Colors.blue;
      case 'PENDING':
        return Colors.orange;
      case 'CONTACTED':
        return Colors.purple;
      case 'QUALIFIED':
        return Colors.green;
      case 'UNQUALIFIED':
        return Colors.red;
      case 'CONVERTED':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getRatingColor(String? rating) {
    if (rating == null) return Colors.grey;
    switch (rating.toLowerCase()) {
      case 'hot':
        return Colors.red;
      case 'warm':
        return Colors.orange;
      case 'cold':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return 'New';
      case 'PENDING':
        return 'Pending';
      case 'CONTACTED':
        return 'Contacted';
      case 'QUALIFIED':
        return 'Qualified';
      case 'UNQUALIFIED':
        return 'Unqualified';
      case 'CONVERTED':
        return 'Converted';
      default:
        return status;
    }
  }

  void _showLeadOptions(BuildContext context, Lead lead) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/lead-detail', arguments: lead.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to edit lead
                },
              ),
              if (!lead.isConverted)
                ListTile(
                  leading: const Icon(Icons.transform),
                  title: const Text('Convert Lead'),
                  onTap: () {
                    Navigator.pop(context);
                    _showConvertDialog(context, lead);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Lead',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, lead);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConvertDialog(BuildContext context, Lead lead) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Convert Lead'),
          content: Text(
            'Convert ${lead.fullName} to a contact and account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _convertLead(lead);
              },
              child: const Text('Convert'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Lead lead) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Lead'),
          content: Text(
            'Are you sure you want to delete ${lead.fullName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteLead(lead);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _convertLead(Lead lead) async {
    final success = await _leadsService.convertLead(lead.id, {
      'createContact': true,
      'createAccount': true,
    });

    if (success) {
      setState(() {
        final index = _leads.indexWhere((l) => l.id == lead.id);
        if (index != -1) {
          _leads[index] = Lead(
            id: lead.id,
            firstName: lead.firstName,
            lastName: lead.lastName,
            email: lead.email,
            phone: lead.phone,
            company: lead.company,
            title: lead.title,
            status: 'CONVERTED',
            leadSource: lead.leadSource,
            industry: lead.industry,
            rating: lead.rating,
            description: lead.description,
            createdAt: lead.createdAt,
            updatedAt: DateTime.now(),
            ownerId: lead.ownerId,
            organizationId: lead.organizationId,
            isConverted: true,
            convertedAt: DateTime.now(),
            convertedAccountId: lead.convertedAccountId,
            convertedContactId: lead.convertedContactId,
            convertedOpportunityId: lead.convertedOpportunityId,
            contactId: lead.contactId,
            owner: lead.owner,
          );
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${lead.fullName} converted successfully')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to convert lead')),
        );
      }
    }
  }

  Future<void> _deleteLead(Lead lead) async {
    final success = await _leadsService.deleteLead(lead.id);

    if (success) {
      setState(() {
        _leads.removeWhere((l) => l.id == lead.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${lead.fullName} deleted successfully')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete lead')),
        );
      }
    }
  }
}