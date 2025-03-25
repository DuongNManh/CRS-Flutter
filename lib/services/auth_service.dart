import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learning_android_1/models/api_response.dart';
import 'package:learning_android_1/models/auth_interface.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:learning_android_1/models/staff_interface.dart';
import 'package:learning_android_1/services/dio_client.dart';
import 'package:learning_android_1/config/api_config.dart';

class AuthService {
  static AuthService? _instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _tokenExpirationKey = 'token_expiration';

  // Private constructor
  AuthService._();

  // Singleton getter
  static Future<AuthService> getInstance() async {
    _instance ??= AuthService._();
    return _instance!;
  }

  // Login method
  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await DioClient.instance.dio.post(
        ApiConfig.loginEndpoint,
        data: LoginRequest(email: email, password: password).toJson(),
      );

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json),
      );

      if (apiResponse.isSuccess == true && apiResponse.data != null) {
        await _storage.write(key: _tokenKey, value: apiResponse.data!.token);
        await _storage.write(
          key: _userKey,
          value: jsonEncode(apiResponse.data!.user.toJson()),
        );
        await setTokenExpiration(apiResponse.data!.expiration);
      }

      return apiResponse;
    } on DioException catch (e) {
      // Handle error response
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (json) => null);
      }
      throw Exception('Failed to login: ${e.message}');
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get stored user
  Future<StaffResponse?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      return StaffResponse.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Store token expiration
  Future<void> setTokenExpiration(DateTime expiration) async {
    await _storage.write(
      key: _tokenExpirationKey,
      value: expiration.toIso8601String(),
    );
  }

  // Get token expiration
  Future<DateTime?> getTokenExpiration() async {
    final expirationStr = await _storage.read(key: _tokenExpirationKey);
    return expirationStr != null ? DateTime.parse(expirationStr) : null;
  }

  // Logout
  Future<void> logout() async {
    try {
      await DioClient.instance.dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      // Handle logout API error if needed
    } finally {
      // Clear stored data
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      await _storage.delete(key: _tokenExpirationKey);
    }
  }
}
