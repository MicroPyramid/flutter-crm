import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bottle_crm/responsive.dart';
import 'package:bottle_crm/ui/widgets/bottom_navigation_bar.dart';
import 'dashboard_controller.dart';

class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dashboardController = DashboardController();
    _dashboardController.addListener(_onDashboardStateChanged);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dashboardController.removeListener(_onDashboardStateChanged);
    _dashboardController.dispose();
    super.dispose();
  }

  void _onDashboardStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadDashboardData() async {
    await _dashboardController.loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/organization_selection', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildAppBar(),
        body: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: _dashboardController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _dashboardController.hasError
                  ? _buildErrorState()
                  : _dashboardController.isEmpty
                      ? _buildEmptyDashboard()
                      : _buildDashboardContent(),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF4980FF),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadDashboardData,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _dashboardController.errorMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadDashboardData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4980FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to BottleCRM!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first account, contact, or lead',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/accounts_list'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4980FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Responsive(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildRecentSection(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 32),
          _buildRecentSection(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildStatsGrid(),
                const SizedBox(height: 32),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 3,
            child: _buildRecentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final isMobile = Responsive.isMobile(context);
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.2 : 1.1,
      children: [
        _buildModernStatCard(
          label: 'Accounts',
          count: _dashboardController.data?.accountsCount ?? 0,
          icon: 'assets/images/accounts_color.svg',
          color: const Color(0xFF4CAF50),
          onTap: () => Navigator.pushNamed(context, '/accounts_list'),
        ),
        _buildModernStatCard(
          label: 'Contacts',
          count: _dashboardController.data?.contactsCount ?? 0,
          icon: 'assets/images/identification.svg',
          color: const Color(0xFF2196F3),
          onTap: () => Navigator.pushNamed(context, '/contacts_list'),
        ),
        _buildModernStatCard(
          label: 'Leads',
          count: _dashboardController.data?.leadsCount ?? 0,
          icon: 'assets/images/flag.svg',
          color: const Color(0xFFFF9800),
          onTap: () => Navigator.pushNamed(context, '/leads_list'),
        ),
        _buildModernStatCard(
          label: 'Opportunities',
          count: _dashboardController.data?.opportunitiesCount ?? 0,
          icon: 'assets/images/opportunities_color.svg',
          color: const Color(0xFF9C27B0),
          onTap: () => Navigator.pushNamed(context, '/opportunities_list'),
        ),
      ],
    );
  }

  Widget _buildModernStatCard({
    required String label,
    required int count,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(
                    width: 3,
                    color: Color(0xFF4980FF),
                  ),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                labelColor: const Color(0xFF4980FF),
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Accounts'),
                  Tab(text: 'Contacts'),
                  Tab(text: 'Opportunities'),
                ],
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecentList('accounts'),
                    _buildRecentList('contacts'),
                    _buildRecentList('opportunities'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentList(String type) {
    List? data;
    
    switch (type) {
      case 'accounts':
        data = _dashboardController.data?.accounts;
        break;
      case 'contacts':
        data = _dashboardController.data?.contacts;
        break;
      case 'opportunities':
        data = _dashboardController.data?.opportunities;
        break;
    }
    
    if (data == null || data.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildRecentListItem(data![index], type);
      },
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No recent $type',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentListItem(dynamic item, String type) {
    String name = '';
    String subtitle = '';
    String? imageUrl;
    
    switch (type) {
      case 'accounts':
        name = item.name ?? '';
        subtitle = item.email ?? '';
        imageUrl = item.createdBy?.profileUrl;
        break;
      case 'contacts':
        name = '${item.firstName ?? ''} ${item.lastName ?? ''}'.trim();
        subtitle = item.primaryEmail ?? '';
        imageUrl = item.createdBy?.profileUrl;
        break;
      case 'opportunities':
        name = item.name ?? '';
        subtitle = item.amount?.toString() ?? '';
        imageUrl = item.createdBy?.profileUrl;
        break;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF4980FF).withOpacity(0.1),
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Color(0xFF4980FF),
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 20,
      ),
      onTap: () {
        // TODO: Navigate to detail screen
      },
    );
  }
}