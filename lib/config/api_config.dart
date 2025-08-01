import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URLs for different environments
  static const String _developmentUrl = 'https://b2ad5166b831.ngrok-free.app';
  static const String _productionUrl = 'https://api.bottlecrm.io';

  // Get base URL based on debug mode
  static String get baseUrl => kDebugMode ? _developmentUrl : _productionUrl;

  static String get apiBaseUrl => baseUrl;

  // Authentication endpoints
  static String get googleLogin => '$apiBaseUrl/auth/google';
  static String get logout => '$apiBaseUrl/auth/logout';

  // Contacts endpoints
  static String get contacts => '$apiBaseUrl/contacts';
  static String get contactById => '$apiBaseUrl/contacts/{id}';
  static String get contactSearch => '$apiBaseUrl/contacts/search';

  // Leads endpoints
  static String get leads => '$apiBaseUrl/leads';
  static String get leadById => '$apiBaseUrl/leads/{id}';
  static String get leadSearch => '$apiBaseUrl/leads/search';
  static String get leadConvert => '$apiBaseUrl/leads/{id}/convert';

  // Deals endpoints
  static String get deals => '$apiBaseUrl/deals';
  static String get dealById => '$apiBaseUrl/deals/{id}';
  static String get dealSearch => '$apiBaseUrl/deals/search';
  static String get dealStages => '$apiBaseUrl/deals/stages';

  // Companies endpoints
  static String get companies => '$apiBaseUrl/companies';
  static String get companyById => '$apiBaseUrl/companies/{id}';
  static String get companySearch => '$apiBaseUrl/companies/search';

  // Organizations endpoints
  static String get organizations => '$apiBaseUrl/organizations';

  // Activities endpoints
  static String get activities => '$apiBaseUrl/activities';
  static String get activityById => '$apiBaseUrl/activities/{id}';
  static String get activityTypes => '$apiBaseUrl/activities/types';

  // Tasks endpoints
  static String get tasks => '$apiBaseUrl/tasks';
  static String get taskById => '$apiBaseUrl/tasks/{id}';
  static String get taskSearch => '$apiBaseUrl/tasks/search';

  // Dashboard endpoints
  static String get dashboard => '$apiBaseUrl/dashboard';

  // Settings endpoints
  static String get settings => '$apiBaseUrl/settings';
  static String get userSettings => '$apiBaseUrl/settings/user';

  // File upload endpoints
  static String get upload => '$apiBaseUrl/upload';
  static String get uploadAvatar => '$apiBaseUrl/upload/avatar';

  // Helper method to replace path parameters
  static String replacePathParam(String url, String param, String value) {
    return url.replaceAll('{$param}', value);
  }

  // Request timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
