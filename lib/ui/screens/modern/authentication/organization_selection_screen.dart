import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:bottle_crm/bloc/auth_bloc.dart';
import 'package:bottle_crm/model/organization.dart';
import 'package:bottle_crm/responsive.dart';
import 'package:bottle_crm/utils/utils.dart';

class OrganizationSelectionScreen extends StatefulWidget {
  const OrganizationSelectionScreen({Key? key}) : super(key: key);
  
  @override
  State createState() => _OrganizationSelectionScreenState();
}

class _OrganizationSelectionScreenState extends State<OrganizationSelectionScreen> 
    with TickerProviderStateMixin {
  List<Organization> organizations = [];
  bool isLoading = false;
  int? selectedIndex;
  String searchQuery = '';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _searchController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchAnimation;
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<Organization> get filteredOrganizations {
    if (searchQuery.isEmpty) return organizations;
    return organizations.where((org) => 
      org.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadOrganizations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _searchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeInOut,
    ));
  }

  void _loadOrganizations() {
    setState(() {
      organizations = authBloc.companies;
    });
    
    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _searchController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectOrganization(int index) async {
    if (isLoading) return;

    // Haptic feedback
    HapticFeedback.lightImpact();
    
    setState(() {
      selectedIndex = index;
      isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('org', organizations[index].id!);
      authBloc.selectedOrganization = organizations[index];
      
      // Fetch required data
      await fetchRequiredData();
      
      // Analytics
      await FirebaseAnalytics.instance.logEvent(
        name: "${organizations[index].name!}_Selected"
      );

      // Navigate with a slight delay for visual feedback
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/dashboard', 
          (route) => false
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedIndex = null;
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select organization. Please try again.'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldPop = await onWillPop();
          if (shouldPop) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4980FF),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildOrganizationsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome back!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Select your organization',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                if (organizations.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${organizations.length} available',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the organization you want to access',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationsList() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Drag indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Search bar (if organizations > 3)
              if (organizations.length > 3) _buildSearchBar(),
              const SizedBox(height: 8),
              Expanded(
                child: organizations.isNotEmpty
                    ? _buildOrganizationsGrid()
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(_searchAnimation),
      child: FadeTransition(
        opacity: _searchAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _searchFocusNode.hasFocus 
                ? const Color(0xFF4980FF).withOpacity(0.3)
                : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchTextController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search organizations...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchTextController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationsGrid() {
    final orgsToShow = filteredOrganizations;
    
    if (orgsToShow.isEmpty && searchQuery.isNotEmpty) {
      return _buildNoSearchResults();
    }
    
    return Responsive(
      mobile: _buildMobileList(orgsToShow),
      tablet: _buildTabletGrid(orgsToShow),
      desktop: _buildDesktopGrid(orgsToShow),
    );
  }

  Widget _buildMobileList(List<Organization> orgs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: orgs.length,
      itemBuilder: (context, index) {
        final orgIndex = organizations.indexOf(orgs[index]);
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          curve: Curves.easeOutBack,
          child: _buildOrganizationCard(orgIndex, true, orgs[index]),
        );
      },
    );
  }

  Widget _buildTabletGrid(List<Organization> orgs) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: orgs.length,
      itemBuilder: (context, index) {
        final orgIndex = organizations.indexOf(orgs[index]);
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          curve: Curves.easeOutBack,
          child: _buildOrganizationCard(orgIndex, false, orgs[index]),
        );
      },
    );
  }

  Widget _buildDesktopGrid(List<Organization> orgs) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.2,
      ),
      itemCount: orgs.length,
      itemBuilder: (context, index) {
        final orgIndex = organizations.indexOf(orgs[index]);
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          curve: Curves.easeOutBack,
          child: _buildOrganizationCard(orgIndex, false, orgs[index]),
        );
      },
    );
  }

  Widget _buildOrganizationCard(int index, bool isList, Organization organization) {
    final isSelected = selectedIndex == index;
    final isAdmin = organization.role == 'ADMIN';
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: isList ? 16 : 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectOrganization(index),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4980FF) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected 
                  ? const Color(0xFF4980FF)
                  : Colors.grey.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected 
                    ? const Color(0xFF4980FF).withOpacity(0.3)
                    : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 20 : 8,
                  offset: Offset(0, isSelected ? 8 : 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Organization Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Colors.white.withOpacity(0.2)
                      : const Color(0xFF4980FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      organization.name?.isNotEmpty == true 
                        ? organization.name![0].toUpperCase()
                        : '?',
                      style: TextStyle(
                        color: isSelected 
                          ? Colors.white
                          : const Color(0xFF4980FF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Organization Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name ?? 'Unknown Organization',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : isAdmin
                              ? const Color(0xFF10B981).withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : isAdmin
                                ? const Color(0xFF10B981).withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isAdmin ? Icons.admin_panel_settings : Icons.person,
                              size: 14,
                              color: isSelected
                                ? Colors.white
                                : isAdmin
                                  ? const Color(0xFF10B981)
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              organization.role ?? 'USER',
                              style: TextStyle(
                                color: isSelected
                                  ? Colors.white
                                  : isAdmin
                                    ? const Color(0xFF10B981)
                                    : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Loading indicator or arrow
                if (isLoading && isSelected)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isSelected 
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[400],
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.search_off_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms\nor check the spelling.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              _searchTextController.clear();
              setState(() {
                searchQuery = '';
              });
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Search'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4980FF),
              side: const BorderSide(color: Color(0xFF4980FF)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.business_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Organizations Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please contact your administrator to get access\nto an organization.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4980FF),
              side: const BorderSide(color: Color(0xFF4980FF)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}