import 'package:flutter/foundation.dart';
import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/opportunities.dart';

@immutable
sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Account> accounts;
  final List<Contact> contacts;
  final List<Opportunity> opportunities;
  final int accountsCount;
  final int contactsCount;
  final int leadsCount;
  final int opportunitiesCount;

  DashboardLoaded({
    required this.accounts,
    required this.contacts,
    required this.opportunities,
    required this.accountsCount,
    required this.contactsCount,
    required this.leadsCount,
    required this.opportunitiesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'accounts': accounts,
      'contacts': contacts,
      'opportunities': opportunities,
      'accountsCount': accountsCount,
      'contactsCount': contactsCount,
      'leadsCount': leadsCount,
      'opportunitiesCount': opportunitiesCount,
    };
  }
}

class DashboardError extends DashboardState {
  final String message;
  final Exception? exception;

  DashboardError(this.message, [this.exception]);
}

class DashboardEmpty extends DashboardState {}