import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';

// Callback khi refresh token thất bại
typedef OnTokenRefreshFailedCallback = void Function();

class ApiService {
  final String baseUrl;
  final http.Client client;
  bool _isRefreshing = false;

  // Callback khi refresh token thất bại
  static OnTokenRefreshFailedCallback? onTokenRefreshFailed;

  ApiService({required this.baseUrl, required this.client});

  // Đặt callback khi refresh token thất bại
  static void setTokenRefreshFailedCallback(
    OnTokenRefreshFailedCallback callback,
  ) {
    onTokenRefreshFailed = callback;
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeaders();

      // Debug log
      debugPrint('GET Request: $baseUrl$endpoint');
      debugPrint('Headers: $headers');

      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      // Debug log
      _logResponse('GET', endpoint, response);

      return _processResponse(response, endpoint);
    } on UnauthorizedException catch (e) {
      // Xử lý token hết hạn
      if (e.message.contains('expired') && !_isRefreshing) {
        debugPrint('Token expired, attempting to refresh...');
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Thử lại request với token mới
          return get(endpoint);
        } else {
          // Nếu refresh token thất bại, gọi callback
          _handleTokenRefreshFailed();
        }
      }
      rethrow;
    } catch (e) {
      debugPrint('GET Error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final headers = await _getHeaders();

      // Debug log
      debugPrint('POST Request: $baseUrl$endpoint');
      debugPrint('Headers: $headers');
      debugPrint('Body: ${json.encode(body)}');

      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      // Debug log
      _logResponse('POST', endpoint, response);

      return _processResponse(response, endpoint);
    } on UnauthorizedException catch (e) {
      // Xử lý token hết hạn
      if (e.message.contains('expired') &&
          !_isRefreshing &&
          endpoint != '/auths/token/refresh') {
        debugPrint('Token expired, attempting to refresh...');
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Thử lại request với token mới
          return post(endpoint, body);
        } else {
          // Nếu refresh token thất bại, gọi callback
          _handleTokenRefreshFailed();
        }
      }
      rethrow;
    } catch (e) {
      debugPrint('POST Error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final headers = await _getHeaders();

      // Debug log
      debugPrint('PUT Request: $baseUrl$endpoint');
      debugPrint('Headers: $headers');
      debugPrint('Body: ${json.encode(body)}');

      final response = await client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      // Debug log
      _logResponse('PUT', endpoint, response);

      return _processResponse(response, endpoint);
    } on UnauthorizedException catch (e) {
      // Xử lý token hết hạn
      if (e.message.contains('expired') && !_isRefreshing) {
        debugPrint('Token expired, attempting to refresh...');
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Thử lại request với token mới
          return put(endpoint, body);
        } else {
          // Nếu refresh token thất bại, gọi callback
          _handleTokenRefreshFailed();
        }
      }
      rethrow;
    } catch (e) {
      debugPrint('PUT Error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();

      // Debug log
      debugPrint('DELETE Request: $baseUrl$endpoint');
      debugPrint('Headers: $headers');

      final response = await client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      // Debug log
      _logResponse('DELETE', endpoint, response);

      return _processResponse(response, endpoint);
    } on UnauthorizedException catch (e) {
      // Xử lý token hết hạn
      if (e.message.contains('expired') && !_isRefreshing) {
        debugPrint('Token expired, attempting to refresh...');
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Thử lại request với token mới
          return delete(endpoint);
        } else {
          // Nếu refresh token thất bại, gọi callback
          _handleTokenRefreshFailed();
        }
      }
      rethrow;
    } catch (e) {
      debugPrint('DELETE Error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }

  Future<bool> _refreshToken() async {
    if (_isRefreshing) return false;

    _isRefreshing = true;
    try {
      debugPrint('Refreshing token...');

      // No body needed as the refresh token is sent via HTTP-only cookie
      final response = await client.post(
        Uri.parse('$baseUrl/auths/token/refresh'),
        headers: {'Content-Type': 'application/json'},
      );

      _logResponse('POST', '/auths/token/refresh', response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final accessToken = responseData['data']['accessToken'];

          // Lưu token mới
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);

          // Cập nhật token trong thông tin người dùng
          final userJson = prefs.getString('user_info');
          if (userJson != null) {
            final userMap = json.decode(userJson) as Map<String, dynamic>;
            userMap['authToken'] = accessToken;
            await prefs.setString('user_info', json.encode(userMap));
          }

          debugPrint('Token refreshed successfully');
          _isRefreshing = false;
          return true;
        }
      }

      debugPrint('Failed to refresh token');
      _isRefreshing = false;

      // Xóa dữ liệu người dùng khi refresh token thất bại
      await _clearUserData();

      return false;
    } catch (e) {
      debugPrint('Error refreshing token: ${e.toString()}');
      _isRefreshing = false;

      // Xóa dữ liệu người dùng khi refresh token thất bại
      await _clearUserData();

      return false;
    }
  }

  // Xóa dữ liệu người dùng khi refresh token thất bại
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_info');
  }

  // Gọi callback khi refresh token thất bại
  void _handleTokenRefreshFailed() {
    if (onTokenRefreshFailed != null) {
      onTokenRefreshFailed!();
    }
  }

  void _logResponse(String method, String endpoint, http.Response response) {
    debugPrint('$method Response: $endpoint');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
  }

  dynamic _processResponse(http.Response response, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      String errorMessage = 'Không có quyền truy cập';
      try {
        final responseData = json.decode(response.body);
        errorMessage = responseData['message'] ?? 'Không có quyền truy cập';
      } catch (e) {
        // Ignore JSON parsing errors
      }
      throw UnauthorizedException(message: errorMessage);
    } else {
      // Special case for empty order list
      if (response.statusCode == 400 &&
          endpoint == '/orders/get-list-order-for-driver') {
        try {
          final responseData = json.decode(response.body);
          final message = responseData['message'] ?? '';
          if (message.toString().contains('Not found')) {
            // Return an empty success response with empty data array
            return {
              'success': true,
              'message': 'No orders found',
              'statusCode': 200,
              'data': [],
            };
          }
        } catch (e) {
          // Ignore JSON parsing errors
        }
      }

      String errorMessage = 'Đã xảy ra lỗi';
      try {
        final responseData = json.decode(response.body);
        errorMessage = responseData['message'] ?? 'Đã xảy ra lỗi';
      } catch (e) {
        // Ignore JSON parsing errors
      }
      throw ServerException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }
  }
}
