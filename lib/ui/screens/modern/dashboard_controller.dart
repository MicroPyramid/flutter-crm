import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/opportunities.dart';
import 'package:bottle_crm/services/crm_services.dart';
import 'dashboard_state.dart';

class DashboardController extends ChangeNotifier {
  DashboardState _state = DashboardInitial();
  
  DashboardState get state => _state;
  
  bool get isLoading => _state is DashboardLoading;
  bool get hasError => _state is DashboardError;
  bool get hasData => _state is DashboardLoaded;
  bool get isEmpty => _state is DashboardEmpty;
  
  DashboardLoaded? get data => _state is DashboardLoaded ? _state as DashboardLoaded : null;
  String get errorMessage => _state is DashboardError ? (_state as DashboardError).message : '';

  void _setState(DashboardState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadDashboard() async {
    if (_state is DashboardLoading) return; // Prevent multiple loading calls
    
    _setState(DashboardLoading());
    
    try {
      final response = await CrmService().getDashboardDetails();
      final res = json.decode(response.body);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }

      // Parse accounts
      final List<Account> accounts = [];
      if (res['accounts'] != null) {
        for (var accountData in res['accounts']) {
          try {
            accounts.add(Account.fromJson(accountData));
          } catch (e) {
            debugPrint('Error parsing account: $e');
          }
        }
      }

      // Parse contacts
      final List<Contact> contacts = [];
      if (res['contacts'] != null) {
        for (var contactData in res['contacts']) {
          try {
            contacts.add(Contact.fromJson(contactData));
          } catch (e) {
            debugPrint('Error parsing contact: $e');
          }
        }
      }

      // Parse opportunities
      final List<Opportunity> opportunities = [];
      if (res['opportunities'] != null) {
        for (var opportunityData in res['opportunities']) {
          try {
            opportunities.add(Opportunity.fromJson(opportunityData));
          } catch (e) {
            debugPrint('Error parsing opportunity: $e');
          }
        }
      }

      // Check if all data is empty
      final accountsCount = res['accounts_count'] ?? 0;
      final contactsCount = res['contacts_count'] ?? 0;
      final leadsCount = res['leads_count'] ?? 0;
      final opportunitiesCount = res['opportunities_count'] ?? 0;

      final totalCount = accountsCount + contactsCount + leadsCount + opportunitiesCount;
      
      if (totalCount == 0 && accounts.isEmpty && contacts.isEmpty && opportunities.isEmpty) {
        _setState(DashboardEmpty());
        return;
      }

      _setState(DashboardLoaded(
        accounts: accounts,
        contacts: contacts,
        opportunities: opportunities,
        accountsCount: accountsCount,
        contactsCount: contactsCount,
        leadsCount: leadsCount,
        opportunitiesCount: opportunitiesCount,
      ));
      
    } catch (e) {
      debugPrint('Dashboard loading error: $e');
      String errorMessage = 'Failed to load dashboard data';
      
      if (e.toString().contains('Network')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication error. Please log in again.';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Access denied. Please check your permissions.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      _setState(DashboardError(errorMessage, e is Exception ? e : Exception(e.toString())));
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  void clearError() {
    if (_state is DashboardError) {
      _setState(DashboardInitial());
    }
  }

  // Helper methods for backward compatibility with existing dashboard bloc
  Map<String, dynamic> get dashboardData {
    if (_state is DashboardLoaded) {
      return (_state as DashboardLoaded).toMap();
    }
    return {};
  }
}