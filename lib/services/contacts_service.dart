import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';
import 'auth_service.dart';

class ContactsService {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  Future<ContactsResponse?> getContacts({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.get(
        ApiConfig.contacts,
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        return ContactsResponse.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to fetch contacts');
      }
    } catch (e) {
      // Error fetching contacts: $e
      return null;
    }
  }

  Future<Contact?> getContactById(String contactId) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final url = ApiConfig.replacePathParam(
        ApiConfig.contactById,
        'id',
        contactId,
      );

      final response = await _apiService.get(url);

      if (response.success && response.data != null) {
        return Contact.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to fetch contact');
      }
    } catch (e) {
      // Error fetching contact: $e
      return null;
    }
  }

  Future<ContactsResponse?> searchContacts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final Map<String, String> queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        ApiConfig.contactSearch,
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        return ContactsResponse.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to search contacts');
      }
    } catch (e) {
      // Error searching contacts: $e
      return null;
    }
  }

  Future<Contact?> createContact(Map<String, dynamic> contactData) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final response = await _apiService.post(ApiConfig.contacts, contactData);

      if (response.success && response.data != null) {
        return Contact.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to create contact');
      }
    } catch (e) {
      // Error creating contact: $e
      return null;
    }
  }

  Future<Contact?> updateContact(
    String contactId,
    Map<String, dynamic> contactData,
  ) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final url = ApiConfig.replacePathParam(
        ApiConfig.contactById,
        'id',
        contactId,
      );

      final response = await _apiService.put(url, contactData);

      if (response.success && response.data != null) {
        return Contact.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to update contact');
      }
    } catch (e) {
      // Error updating contact: $e
      return null;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      if (!_authService.isLoggedIn) {
        throw Exception('User not authenticated');
      }

      final url = ApiConfig.replacePathParam(
        ApiConfig.contactById,
        'id',
        contactId,
      );

      final response = await _apiService.delete(url);

      return response.success;
    } catch (e) {
      // Error deleting contact: $e
      return false;
    }
  }
}
