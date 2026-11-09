import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class ApiService {
  static const String baseUrl = AppConfig.apiBaseUrl;

  // Reusable HTTP POST function
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireAuth = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (requireAuth && (token == null || token.isEmpty)) {
      throw Exception('Please login first');
    }
    debugPrint('Calling API: $baseUrl$endpoint');
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (requireAuth)
          'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 15));

    final result = jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as Map<String, dynamic>;

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        result['detail'] ??
        result['Details'] ??
        result.toString(),
      );
    }

    return result;
  }

   // Reusable HTTP GET Function
  static Future<Map<String, dynamic>> get(
    String endpoint,
  ) async {
    // 1. Retrieve saved Token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      throw Exception('Please login first');
    }

    debugPrint('Calling API: $baseUrl$endpoint');
    // 2. Send GET Request to Django
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15));

    // 3. Decode JSON Response
    final result = jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as Map<String, dynamic>;

    // 4. Handle unsuccessful Response
    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        result['detail'] ??
        result.toString(),
      );
    }

    return result;
  }

  // Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final result = await post(
      '/api/auth/login/',
      {
        'login': email,
        'password': password,
      },
      requireAuth: false,
    );

    final token = result['access_token'] as String;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', token);
    return result;
  }

  // Get Current Login User
  static Future<Map<String, dynamic>> getUser() {
    return get('/api/auth/me/');
  }

  // View Tasks
  static Future<List<Map<String, dynamic>>> viewTasks() async {
    final result = await post('/api/tasks/viewTask/', {});

    return (result['task'] as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // Create Task
  static Future<Map<String, dynamic>> createTask(
    Map<String, dynamic> taskData,
  ) {
    return post('/api/tasks/createTask/', taskData);
  }

  // Edit Task
  static Future<Map<String, dynamic>> editTask(
    Map<String, dynamic> taskData,
  ) {
    return post('/api/tasks/editTask/', taskData);
  }

  // View SubTasks
  static Future<Map<String, dynamic>> viewSubTasks(
    String taskId,
  ) {
    return post('/api/tasks/viewSubTask/', {
      'task_id': taskId,
    });
  }

  // Create SubTask
  static Future<Map<String, dynamic>> createSubTask(
    Map<String, dynamic> subTaskData,
  ) {
    return post('/api/tasks/createSubTask/', subTaskData);
  }

  // Edit SubTask
  static Future<Map<String, dynamic>> editSubTask(
    Map<String, dynamic> subTaskData,
  ) {
    return post('/api/tasks/editSubTask/', subTaskData);
  }
}
