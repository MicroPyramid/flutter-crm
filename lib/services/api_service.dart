import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    required this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse(success: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(
    String message,
    int statusCode, [
    Map<String, dynamic>? errors,
  ]) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = Map.from(ApiConfig.defaultHeaders);

    if (requiresAuth) {
      final token = await _authService.getJwtToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Add selected organization ID to headers for API calls
      final selectedOrg = _authService.selectedOrganization;
      if (selectedOrg != null) {
        headers['X-Organization-ID'] = selectedOrg.id;
      }
    }

    return headers;
  }

  Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final Map<String, dynamic> body = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(fromJson(body), response.statusCode);
      } else {
        // Handle unauthorized access - logout user
        if (response.statusCode == 401) {
          await _authService.logout();
        }

        return ApiResponse.error(
          body['message'] ?? 'Request failed',
          response.statusCode,
          body['errors'],
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: $e',
        response.statusCode,
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> _handleMapResponse(
    http.Response response,
  ) async {
    return _handleResponse<Map<String, dynamic>>(response, (json) => json);
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> _handleListResponse(
    http.Response response,
  ) async {
    try {
      final dynamic body = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (body is Map<String, dynamic> && body.containsKey('data')) {
          final List<dynamic> data = body['data'] as List<dynamic>;
          final List<Map<String, dynamic>> result = data
              .cast<Map<String, dynamic>>();
          return ApiResponse.success(result, response.statusCode);
        } else if (body is List<dynamic>) {
          final List<Map<String, dynamic>> result = body
              .cast<Map<String, dynamic>>();
          return ApiResponse.success(result, response.statusCode);
        }
      }

      final Map<String, dynamic> errorBody = body is Map<String, dynamic>
          ? body
          : {};
      return ApiResponse.error(
        errorBody['message'] ?? 'Request failed',
        response.statusCode,
        errorBody['errors'],
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: $e',
        response.statusCode,
      );
    }
  }

  // GET request
  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(endpoint);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .get(uri, headers: headers)
          .timeout(ApiConfig.receiveTimeout);

      return _handleMapResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  // GET request for lists
  Future<ApiResponse<List<Map<String, dynamic>>>> getList(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      Uri uri = Uri.parse(endpoint);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .get(uri, headers: headers)
          .timeout(ApiConfig.receiveTimeout);

      return _handleListResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  // POST request
  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .post(Uri.parse(endpoint), headers: headers, body: json.encode(data))
          .timeout(ApiConfig.sendTimeout);

      return _handleMapResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  // PUT request
  Future<ApiResponse<Map<String, dynamic>>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .put(Uri.parse(endpoint), headers: headers, body: json.encode(data))
          .timeout(ApiConfig.sendTimeout);

      return _handleMapResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  // DELETE request
  Future<ApiResponse<Map<String, dynamic>>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .delete(Uri.parse(endpoint), headers: headers)
          .timeout(ApiConfig.receiveTimeout);

      return _handleMapResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  // PATCH request
  Future<ApiResponse<Map<String, dynamic>>> patch(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await _client
          .patch(Uri.parse(endpoint), headers: headers, body: json.encode(data))
          .timeout(ApiConfig.sendTimeout);

      return _handleMapResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection', 0);
    } on HttpException {
      return ApiResponse.error('HTTP error occurred', 0);
    } catch (e) {
      return ApiResponse.error('Request failed: $e', 0);
    }
  }

  void dispose() {
    _client.close();
  }
}
