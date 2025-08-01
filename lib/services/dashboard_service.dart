import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  DashboardMetrics? _dashboardMetrics;

  DashboardMetrics? get dashboardMetrics => _dashboardMetrics;

  Future<DashboardMetrics?> loadDashboardData() async {
    try {
      final apiService = ApiService();
      final response = await apiService.get(ApiConfig.dashboard);

      if (response.success && response.data != null) {
        _dashboardMetrics = DashboardMetrics.fromJson(response.data!);
        debugPrint(
          'Dashboard data loaded: ${_dashboardMetrics!.totalContacts} contacts, ${_dashboardMetrics!.totalLeads} leads',
        );
        debugPrint(
          'Opportunities: ${_dashboardMetrics!.totalOpportunities}, Revenue: \$${_dashboardMetrics!.opportunityRevenue}',
        );
        return _dashboardMetrics;
      } else {
        debugPrint('Failed to load dashboard data: ${response.message}');
        return null;
      }
    } catch (e) {
      debugPrint('Dashboard service error: $e');
      return null;
    }
  }

  void clearDashboardData() {
    _dashboardMetrics = null;
  }
}
