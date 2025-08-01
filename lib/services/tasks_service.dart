import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';

class TasksService {
  final ApiService _apiService = ApiService();

  Future<TasksResponse?> getTasks({
    String? status,
    String? priority,
    String? ownerId,
    String? accountId,
    String? contactId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;
      if (ownerId != null) queryParams['ownerId'] = ownerId;
      if (accountId != null) queryParams['accountId'] = accountId;
      if (contactId != null) queryParams['contactId'] = contactId;
      queryParams['limit'] = limit.toString();
      queryParams['offset'] = offset.toString();

      final response = await _apiService.get(
        ApiConfig.tasks,
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        return TasksResponse.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting tasks: $e');
      return null;
    }
  }

  Future<Task?> getTaskById(String taskId) async {
    try {
      final response = await _apiService.get(
        ApiConfig.replacePathParam(ApiConfig.taskById, 'id', taskId),
      );

      if (response.success && response.data != null) {
        return Task.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting task by ID: $e');
      return null;
    }
  }

  Future<Task?> createTask({
    required String subject,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? ownerId,
    String? accountId,
    String? contactId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'subject': subject,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
        if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
        if (ownerId != null) 'ownerId': ownerId,
        if (accountId != null) 'accountId': accountId,
        if (contactId != null) 'contactId': contactId,
      };

      final response = await _apiService.post(ApiConfig.tasks, data);

      if (response.success && response.data != null) {
        return Task.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('Error creating task: $e');
      return null;
    }
  }

  Future<Task?> updateTask(
    String taskId, {
    String? subject,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? ownerId,
    String? accountId,
    String? contactId,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (subject != null) data['subject'] = subject;
      if (description != null) data['description'] = description;
      if (status != null) data['status'] = status;
      if (priority != null) data['priority'] = priority;
      if (dueDate != null) data['dueDate'] = dueDate.toIso8601String();
      if (ownerId != null) data['ownerId'] = ownerId;
      if (accountId != null) data['accountId'] = accountId;
      if (contactId != null) data['contactId'] = contactId;

      final response = await _apiService.put(
        ApiConfig.replacePathParam(ApiConfig.taskById, 'id', taskId),
        data,
      );

      if (response.success && response.data != null) {
        return Task.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('Error updating task: $e');
      return null;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final response = await _apiService.delete(
        ApiConfig.replacePathParam(ApiConfig.taskById, 'id', taskId),
      );

      return response.success;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }

  Future<TasksResponse?> searchTasks({
    required String query,
    String? status,
    String? priority,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'q': query,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;

      final response = await _apiService.get(
        ApiConfig.taskSearch,
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        return TasksResponse.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      debugPrint('Error searching tasks: $e');
      return null;
    }
  }
}
