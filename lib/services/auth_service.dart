import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';

// Authentication service responsible for handling user login and registration logic
// Methods: - login: verifies username against locally stored registered users and returns a token if valid
//          - register: posts new user data to the API and stores the username locally if registration is successful
class AuthService {
  final Dio _dio = ApiClient.instance;

  /// Login by verifying username against locally stored registered users
  /// Returns a token if valid, throws exception if invalid or not registered
  Future<String> login(String username, String password) async {
    try {
      debugPrint("Logging in with username: $username");

      // Get registered usernames from local storage (secure - no sensitive data exposed)
      final prefs = await SharedPreferences.getInstance();
      final registeredUsersJson = prefs.getStringList('registered_users') ?? [];
      
      // Check if username exists in registered users
      final userExists = registeredUsersJson.contains(username);
      
      if (!userExists) {
        throw Exception('Invalid username or password');
      }

      // Create a token based on username (for demo purposes)
      // In a real app, the server would validate credentials and return a token
      final token = 'token_${username}_${DateTime.now().millisecondsSinceEpoch}';
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Register a new user by posting to /users endpoint and storing username locally
  Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    try {
      debugPrint("Registering user: $username");

      // Check if username already registered locally
      final prefs = await SharedPreferences.getInstance();
      final registeredUsersJson = prefs.getStringList('registered_users') ?? [];
      
      if (registeredUsersJson.contains(username)) {
        throw Exception('Username already exists');
      }

      // Mock user data for registration (since API doesn't actually create users, we simulate it)
      final userData = {
        'username': username,
        'password': password,
        'email': '$username@gmail.com',
        'phone': '1234567890',
        'address': {
          'street': 'Some Street',
          'city': 'Dubai',
          'zipcode': '00000',
          'geo': {
            'lat': '0',
            'lng': '0',
          },
        },
      };

      final resp = await _dio.post(
        '/users',
        data: userData,
        options: Options(
          contentType: Headers.jsonContentType,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint("Register response: ${resp.statusCode} - ${resp.data}");

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        // Add username to locally registered users (secure - password not stored)
        registeredUsersJson.add(username);
        await prefs.setStringList('registered_users', registeredUsersJson);
        
        return Map<String, dynamic>.from(resp.data);
      }

      throw Exception(
        'Registration failed: ${resp.statusCode} ${resp.data ?? resp.statusMessage}',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Registration failed: ${e.response?.statusCode} ${e.response?.data}',
        );
      }
      throw Exception('Registration failed: ${e.message}');
    }
  }
}
