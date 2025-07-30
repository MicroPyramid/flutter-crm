import 'package:flutter/foundation.dart';

class ApiConfig {
  // Environment-based API URLs
  static const String DEV_API_URL = 'http://192.168.0.106:3001/';
  static const String PROD_API_URL = 'https://api.bottlecrm.io/';
  
  // Available APIs for manual switching
  static const List<String> AVAILABLE_APIS = [
    DEV_API_URL,
    PROD_API_URL,
  ];
  
  // Current API URL (can be changed at runtime)
  static String? _currentApiUrl;
  
  static void setApiUrl(String url) {
    _currentApiUrl = url.endsWith('/') ? url : '$url/';
  }
  
  static String getApiUrl() {
    if (_currentApiUrl != null) {
      return _currentApiUrl!;
    }
    
    // Auto-select based on build mode
    if (kDebugMode) {
      return DEV_API_URL;  // Development/Debug builds
    } else {
      return PROD_API_URL; // Production/Release builds
    }
  }
  
  static bool isDebugMode() {
    return kDebugMode;
  }
  
  static String getCurrentEnvironment() {
    return kDebugMode ? 'Development' : 'Production';
  }
}