import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';

class LeadsService {
  static final LeadsService _instance = LeadsService._internal();
  factory LeadsService() => _instance;
  LeadsService._internal();

  final ApiService _apiService = ApiService();

  // Cache for leads metadata (if any)
  List<String>? _cachedStatuses;
  List<String>? _cachedSources;
  List<String>? _cachedRatings;
  List<String>? _cachedIndustries;

  // Initialize service - load cached metadata
  Future<void> initialize() async {
    await _loadCachedMetadata();
  }

  // Load leads with pagination
  Future<LeadsResponse?> getLeads({
    int page = 1,
    int limit = 10,
    String? status,
    String? leadSource,
    String? rating,
    String? industry,
    String? searchQuery,
    bool? converted,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (leadSource != null && leadSource.isNotEmpty) {
        queryParams['leadSource'] = leadSource;
      }
      if (rating != null && rating.isNotEmpty) {
        queryParams['rating'] = rating;
      }
      if (industry != null && industry.isNotEmpty) {
        queryParams['industry'] = industry;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (converted != null) {
        queryParams['converted'] = converted.toString();
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final url = queryString.isNotEmpty
          ? '${ApiConfig.leads}?$queryString'
          : ApiConfig.leads;

      debugPrint('LeadsService: Fetching leads from $url');

      final response = await _apiService.get(url);

      if (response.success && response.data != null) {
        final leadsResponse = LeadsResponse.fromJson(response.data!);
        debugPrint(
          'LeadsService: Successfully loaded ${leadsResponse.leads.length} leads',
        );
        return leadsResponse;
      } else {
        debugPrint('LeadsService: Failed to load leads - ${response.message}');
        return null;
      }
    } catch (e) {
      debugPrint('LeadsService: Error loading leads - $e');
      return null;
    }
  }

  // Get a single lead by ID
  Future<Lead?> getLeadById(String id) async {
    try {
      final url = ApiConfig.leadById.replaceAll('{id}', id);
      final response = await _apiService.get(url);

      if (response.success && response.data != null) {
        return Lead.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('LeadsService: Error loading lead $id - $e');
      return null;
    }
  }

  // Search leads
  Future<LeadsResponse?> searchLeads({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final url = '${ApiConfig.leadSearch}?$queryString';
      final response = await _apiService.get(url);

      if (response.success && response.data != null) {
        return LeadsResponse.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('LeadsService: Error searching leads - $e');
      return null;
    }
  }

  // Create a new lead
  Future<Lead?> createLead(Map<String, dynamic> leadData) async {
    try {
      final response = await _apiService.post(ApiConfig.leads, leadData);

      if (response.success && response.data != null) {
        return Lead.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('LeadsService: Error creating lead - $e');
      return null;
    }
  }

  // Update an existing lead
  Future<Lead?> updateLead(String id, Map<String, dynamic> leadData) async {
    try {
      final url = ApiConfig.leadById.replaceAll('{id}', id);
      final response = await _apiService.put(url, leadData);

      if (response.success && response.data != null) {
        return Lead.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('LeadsService: Error updating lead - $e');
      return null;
    }
  }

  // Delete a lead
  Future<bool> deleteLead(String id) async {
    try {
      final url = ApiConfig.leadById.replaceAll('{id}', id);
      final response = await _apiService.delete(url);
      return response.success;
    } catch (e) {
      debugPrint('LeadsService: Error deleting lead - $e');
      return false;
    }
  }

  // Convert lead to contact/account/opportunity
  Future<bool> convertLead(
    String id,
    Map<String, dynamic> conversionData,
  ) async {
    try {
      final url = ApiConfig.leadConvert.replaceAll('{id}', id);
      final response = await _apiService.post(url, conversionData);
      return response.success;
    } catch (e) {
      debugPrint('LeadsService: Error converting lead - $e');
      return false;
    }
  }

  // Load cached metadata from SharedPreferences
  Future<void> _loadCachedMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final statusesJson = prefs.getString('leads_statuses');
      if (statusesJson != null) {
        final statusesList = jsonDecode(statusesJson) as List;
        _cachedStatuses = statusesList.cast<String>();
      }

      final sourcesJson = prefs.getString('leads_sources');
      if (sourcesJson != null) {
        final sourcesList = jsonDecode(sourcesJson) as List;
        _cachedSources = sourcesList.cast<String>();
      }

      final ratingsJson = prefs.getString('leads_ratings');
      if (ratingsJson != null) {
        final ratingsList = jsonDecode(ratingsJson) as List;
        _cachedRatings = ratingsList.cast<String>();
      }

      final industriesJson = prefs.getString('leads_industries');
      if (industriesJson != null) {
        final industriesList = jsonDecode(industriesJson) as List;
        _cachedIndustries = industriesList.cast<String>();
      }

      debugPrint('LeadsService: Loaded cached metadata');
    } catch (e) {
      debugPrint('LeadsService: Error loading cached metadata - $e');
    }
  }

  // Clear all cached data (call this on logout or organization change)
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('leads_statuses');
      await prefs.remove('leads_sources');
      await prefs.remove('leads_ratings');
      await prefs.remove('leads_industries');

      _cachedStatuses = null;
      _cachedSources = null;
      _cachedRatings = null;
      _cachedIndustries = null;

      debugPrint('LeadsService: Cleared all cached data');
    } catch (e) {
      debugPrint('LeadsService: Error clearing cache - $e');
    }
  }

  // Getters for cached metadata
  List<String>? get statuses => _cachedStatuses;
  List<String>? get sources => _cachedSources;
  List<String>? get ratings => _cachedRatings;
  List<String>? get industries => _cachedIndustries;
}
