import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../services/leads_service.dart';
import '../models/api_models.dart';
import 'contacts_list_screen.dart';
import 'tasks_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const ContactsListScreen(),
    const LeadsTab(),
    const TasksListScreen(),
    const ProfileTab(),
  ]; // Keep concise, no extra comments

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Leads',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DashboardMetrics? _dashboardMetrics;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final dashboardService = DashboardService();
      final metrics = await dashboardService.loadDashboardData();
      if (mounted) {
        setState(() {
          _dashboardMetrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final user = authService.currentUser;
    final selectedOrg = authService.selectedOrganization;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? 'User',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedOrg != null) ...[
                Text(
                  selectedOrg.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;
                    if (constraints.maxWidth < 600) {
                      crossAxisCount = 2; // Mobile
                    } else if (constraints.maxWidth < 900) {
                      crossAxisCount = 3; // Small tablet
                    } else {
                      crossAxisCount = 4; // Large tablet/desktop
                    }
                    
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                    _buildStatCard(
                      title: 'Contacts',
                      value: '${_dashboardMetrics?.totalContacts ?? 0}',
                      icon: Icons.people,
                      color: Colors.blue,
                      theme: theme,
                    ),
                    _buildStatCard(
                      title: 'Leads',
                      value: '${_dashboardMetrics?.totalLeads ?? 0}',
                      icon: Icons.trending_up,
                      color: Colors.green,
                      theme: theme,
                    ),
                    _buildStatCard(
                      title: 'Opportunities',
                      value: '${_dashboardMetrics?.totalOpportunities ?? 0}',
                      icon: Icons.handshake,
                      color: Colors.orange,
                      theme: theme,
                    ),
                    _buildStatCard(
                      title: 'Tasks',
                      value: '${_dashboardMetrics?.pendingTasks ?? 0}',
                      icon: Icons.task_alt,
                      color: Colors.red,
                      theme: theme,
                    ),
                    _buildStatCard(
                      title: 'Revenue',
                      value:
                          '\$${(_dashboardMetrics?.opportunityRevenue ?? 0).toStringAsFixed(0)}',
                      icon: Icons.attach_money,
                      color: Colors.green,
                      theme: theme,
                    ),
                    _buildStatCard(
                      title: 'Accounts',
                      value: '${_dashboardMetrics?.totalAccounts ?? 0}',
                      icon: Icons.business,
                      color: Colors.purple,
                      theme: theme,
                    ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeadsTab extends StatefulWidget {
  const LeadsTab({super.key});

  @override
  State<LeadsTab> createState() => _LeadsTabState();
}

class _LeadsTabState extends State<LeadsTab> {
  final LeadsService _leadsService = LeadsService();
  final ScrollController _scrollController = ScrollController();

  List<Lead> _leads = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  Pagination? _pagination;

  @override
  void initState() {
    super.initState();
    _loadLeads();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreLeads();
    }
  }

  Future<void> _loadLeads({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _leads.clear();
        _currentPage = 1;
        _hasMoreData = true;
      }
    });

    try {
      final response = await _leadsService.getLeads(
        page: refresh ? 1 : _currentPage,
        limit: 10,
      );

      if (response != null && mounted) {
        setState(() {
          if (refresh) {
            _leads = response.leads;
            _currentPage = 1;
          } else {
            _leads.addAll(response.leads);
          }
          _pagination = response.pagination;
          _hasMoreData = response.pagination.hasNext;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading leads: $e')));
      }
    }
  }

  Future<void> _loadMoreLeads() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    try {
      final response = await _leadsService.getLeads(
        page: _currentPage,
        limit: 10,
      );

      if (response != null && mounted) {
        setState(() {
          _leads.addAll(response.leads);
          _pagination = response.pagination;
          _hasMoreData = response.pagination.hasNext;
          _isLoadingMore = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage--; // Revert page increment on error
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage--; // Revert page increment on error
        });
      }
    }
  }

  Future<void> _refreshLeads() async {
    await _loadLeads(refresh: true);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return Colors.blue;
      case 'CONTACTED':
        return Colors.orange;
      case 'QUALIFIED':
        return Colors.green;
      case 'LOST':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getRatingColor(String? rating) {
    switch (rating?.toLowerCase()) {
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

  Widget _buildLeadCard(Lead lead) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/lead-detail', arguments: lead.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lead.title ?? 'Untitled Lead',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(lead.status).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(lead.status).withAlpha(100),
                      ),
                    ),
                    child: Text(
                      lead.status,
                      style: TextStyle(
                        color: _getStatusColor(lead.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              if (lead.description != null) ...[
                Text(
                  lead.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Company row
              if (lead.company != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lead.company!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Bottom row with rating, source, and owner
              Row(
                children: [
                  if (lead.rating != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(lead.rating).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getRatingColor(lead.rating).withAlpha(100),
                        ),
                      ),
                      child: Text(
                        lead.rating!,
                        style: TextStyle(
                          color: _getRatingColor(lead.rating),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  Text(
                    lead.leadSource,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),

                  const Spacer(),

                  if (lead.owner != null)
                    Text(
                      lead.owner!.fullName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter functionality coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(
                context,
              ).pushNamed('/lead-create');
              // If lead was created successfully, refresh the leads list
              if (result == true) {
                _loadLeads(refresh: true);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Leads count and pagination info
          if (_pagination != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Showing ${_leads.length} of ${_pagination!.total} leads',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Page ${_pagination!.page} of ${_pagination!.pages}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Leads list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshLeads,
              child: _isLoading && _leads.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _leads.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.trending_up_outlined,
                                  size: 64,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No leads found',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pull down to refresh or create your first lead',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _leads.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _leads.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return _buildLeadCard(_leads[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // User Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : null,
              child: user?.profileImage == null
                  ? Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'U',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // User Name
            Text(
              user?.name ?? 'Unknown User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // User Email
            Text(
              user?.email ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 32),

            // Profile Options
            Card(
              child: Column(
                children: [
                  if (authService.selectedOrganization != null)
                    ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(authService.selectedOrganization!.name),
                      subtitle: Text(
                        'Role: ${authService.selectedOrganization!.role}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('/company-selection');
                      },
                    ),
                  if (authService.selectedOrganization != null)
                    const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/help-support');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushNamed('/about');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
