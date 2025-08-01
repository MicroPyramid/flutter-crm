import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class OrganizationsPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  OrganizationsPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory OrganizationsPagination.fromJson(Map<String, dynamic> json) {
    return OrganizationsPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}

class Organization {
  final String id;
  final String name;
  final String? domain;
  final String? logo;
  final String? website;
  final String? industry;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userRole;
  final DateTime? joinedAt;

  Organization({
    required this.id,
    required this.name,
    this.domain,
    this.logo,
    this.website,
    this.industry,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.userRole,
    this.joinedAt,
  });

  // Backward compatibility getter for existing code
  String get role => userRole ?? 'USER';

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      domain: json['domain'],
      logo: json['logo'],
      website: json['website'],
      industry: json['industry'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      userRole: json['userRole'] ?? json['role'],
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'logo': logo,
      'website': website,
      'industry': industry,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userRole': userRole ?? 'USER',
      'joinedAt': joinedAt?.toIso8601String(),
    };
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Initialize GoogleSignIn instance (singleton in v7.1.1)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const String _jwtTokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _organizationsKey = 'organizations';
  static const String _selectedOrgKey = 'selected_organization';

  User? _currentUser;
  String? _jwtToken;
  List<Organization>? _organizations;
  Organization? _selectedOrganization;
  OrganizationsPagination? _organizationsPagination;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && _jwtToken != null;
  String? get jwtToken => _jwtToken;
  List<Organization>? get organizations => _organizations;
  Organization? get selectedOrganization => _selectedOrganization;
  bool get hasSelectedOrganization => _selectedOrganization != null;
  OrganizationsPagination? get organizationsPagination =>
      _organizationsPagination;

  // Initialize service - call this in main.dart
  Future<void> initialize() async {
    try {
      // Initialize Google Sign-In (required in v7.1.1)
      await _googleSignIn.initialize();
      debugPrint('Google Sign-In initialized successfully');
    } catch (e) {
      debugPrint('Google Sign-In initialization failed: $e');
    }

    await _loadDataFromStorage();
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      debugPrint('Google Sign-In: Initiating authentication process...');

      // Check if platform supports authenticate method
      if (!_googleSignIn.supportsAuthenticate()) {
        debugPrint(
          'Google Sign-In: Platform does not support authenticate method',
        );
        return false;
      }

      // Authenticate with Google (new method in v7.1.1)
      final googleUser = await _googleSignIn.authenticate();

      debugPrint('Google Sign-In: Authentication successful');
      debugPrint('User authenticated: ${googleUser.email}');

      // Get authentication token from Google
      final authentication = googleUser.authentication;
      final idToken = authentication.idToken;

      if (idToken == null) {
        debugPrint('Google Sign-In: Failed to get ID token');
        return false;
      }

      debugPrint('Google Sign-In: Got ID token, sending to backend...');

      // Send Google token to backend
      final apiService = ApiService();
      final response = await apiService.post(ApiConfig.googleLogin, {
        'idToken': idToken,
      }, requiresAuth: false);

      if (!response.success || response.data == null) {
        debugPrint(
          'Google Sign-In: Backend authentication failed: ${response.message}',
        );
        return false;
      }

      await _handleAuthResponse(response.data!);

      // Log user info after successful authentication
      if (_currentUser != null) {
        debugPrint('User ID: ${_currentUser!.id}');
        debugPrint('User Email: ${_currentUser!.email}');
        debugPrint('User Name: ${_currentUser!.name}');
        debugPrint('User Profile Image: ${_currentUser!.profileImage}');
        debugPrint(
          'Organizations: ${_organizations?.map((org) => '${org.name} (${org.role})').join(', ')}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      return false;
    }
  }

  // Handle authentication response from backend
  Future<void> _handleAuthResponse(Map<String, dynamic> data) async {
    _jwtToken = data['JWTtoken'];

    if (data['user'] != null) {
      _currentUser = User.fromJson(data['user']);
    }

    if (data['organizations'] != null) {
      _organizations = (data['organizations'] as List)
          .map((org) => Organization.fromJson(org))
          .toList();
    }

    // Clear any previously selected organization on fresh login
    // User must select a company again
    _selectedOrganization = null;
    await _clearSelectedOrganization();

    await _saveDataToStorage();
  }

  // Select organization for API calls
  Future<void> selectOrganization(Organization organization) async {
    _selectedOrganization = organization;
    await _saveSelectedOrganization();
    debugPrint(
      'Selected organization: ${organization.name} (${organization.role})',
    );
  }

  // Fetch organizations from API with pagination support
  Future<bool> fetchOrganizations({
    int page = 1,
    int limit = 10,
    bool append = false,
  }) async {
    try {
      debugPrint(
        'Fetching organizations from API (page: $page, limit: $limit)...',
      );

      final apiService = ApiService();
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      final response = await apiService.get(
        ApiConfig.organizations,
        queryParams: queryParams,
        requiresAuth: true,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        if (data['success'] == true && data['organizations'] != null) {
          final organizationsData = data['organizations'] as List;
          final newOrganizations = organizationsData
              .map((org) => Organization.fromJson(org))
              .toList();

          // Handle pagination info
          if (data['pagination'] != null) {
            _organizationsPagination = OrganizationsPagination.fromJson(
              data['pagination'],
            );
          }

          // Append or replace organizations
          if (append && _organizations != null) {
            _organizations!.addAll(newOrganizations);
          } else {
            _organizations = newOrganizations;
          }

          // Save to storage for offline access
          await _saveDataToStorage();

          debugPrint(
            'Fetched ${newOrganizations.length} organizations (total: ${_organizations!.length})',
          );
          return true;
        }
      }

      debugPrint('Failed to fetch organizations: ${response.message}');
      return false;
    } catch (e) {
      debugPrint('Error fetching organizations: $e');
      return false;
    }
  }

  // Refresh organizations (fetch and update)
  Future<bool> refreshOrganizations() async {
    return await fetchOrganizations();
  }

  // Load more organizations (for pagination)
  Future<bool> loadMoreOrganizations() async {
    if (_organizationsPagination?.hasNext == true) {
      final nextPage = (_organizationsPagination?.page ?? 0) + 1;
      return await fetchOrganizations(page: nextPage, append: true);
    }
    return false;
  }

  // Get JWT token for API calls
  Future<String?> getJwtToken() async {
    return _jwtToken;
  }

  // Logout
  Future<void> logout() async {
    try {
      // Notify backend about logout
      if (_jwtToken != null) {
        final apiService = ApiService();
        await apiService.post(ApiConfig.logout, {}, requiresAuth: true);
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      // Clear all local authentication data
      await _clearDataFromStorage();

      _currentUser = null;
      _jwtToken = null;
      _organizations = null;
      _selectedOrganization = null;
      _organizationsPagination = null;

      debugPrint('Logout: All authentication data cleared');
    }
  }

  // Storage methods
  Future<void> _saveDataToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    if (_jwtToken != null) {
      await prefs.setString(_jwtTokenKey, _jwtToken!);
    }

    if (_currentUser != null) {
      await prefs.setString(_userKey, json.encode(_currentUser!.toJson()));
    }

    if (_organizations != null) {
      final orgsJson = _organizations!.map((org) => org.toJson()).toList();
      await prefs.setString(_organizationsKey, json.encode(orgsJson));
    }
  }

  Future<void> _saveSelectedOrganization() async {
    if (_selectedOrganization != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _selectedOrgKey,
        json.encode(_selectedOrganization!.toJson()),
      );
    }
  }

  Future<void> _clearSelectedOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedOrgKey);
  }

  Future<void> _loadDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    _jwtToken = prefs.getString(_jwtTokenKey);

    final userString = prefs.getString(_userKey);
    if (userString != null) {
      final userData = json.decode(userString);
      _currentUser = User.fromJson(userData);
    }

    final orgsString = prefs.getString(_organizationsKey);
    if (orgsString != null) {
      final orgsData = json.decode(orgsString) as List;
      _organizations = orgsData
          .map((org) => Organization.fromJson(org))
          .toList();
    }

    final selectedOrgString = prefs.getString(_selectedOrgKey);
    if (selectedOrgString != null) {
      final selectedOrgData = json.decode(selectedOrgString);
      _selectedOrganization = Organization.fromJson(selectedOrgData);
    }
  }

  Future<void> _clearDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtTokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_organizationsKey);
    await prefs.remove(_selectedOrgKey);
  }

  // Development helper method to clear all stored auth data
  Future<void> clearAllAuthData() async {
    await _clearDataFromStorage();
    _currentUser = null;
    _jwtToken = null;
    _organizations = null;
    _selectedOrganization = null;
    debugPrint('All authentication data cleared');
  }
}
