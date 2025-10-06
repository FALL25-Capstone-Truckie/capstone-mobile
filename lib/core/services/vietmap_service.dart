import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';
import 'api_service.dart';

class VietMapService {
  final ApiService _apiService;
  static const String _cacheKey = 'vietmap_style_cache';
  static const Duration _cacheDuration = Duration(days: 7); // Cache 7 ngày
  static String? _cachedStyle;
  static DateTime? _cacheTimestamp;

  VietMapService({required ApiService apiService}) : _apiService = apiService;

  Future<String> getMobileStyles() async {
    try {
      // Kiểm tra cache trong memory trước
      if (_cachedStyle != null && _cacheTimestamp != null) {
        final now = DateTime.now();
        if (now.difference(_cacheTimestamp!) < _cacheDuration) {
          debugPrint('Using in-memory cached VietMap style');
          return _cachedStyle!;
        }
      }

      // Kiểm tra cache trong SharedPreferences
      final cachedData = await _getCachedStyle();
      if (cachedData != null) {
        // Lưu vào memory cache
        _cachedStyle = cachedData;
        _cacheTimestamp = DateTime.now();
        debugPrint('Using persistent cached VietMap style');
        return cachedData;
      }

      // Nếu không có cache, gọi API
      debugPrint('Fetching VietMap style from API');
      final response = await _apiService.get('/vietmap/mobile-styles');

      // Kiểm tra response có đúng định dạng style map không
      if (response is Map &&
          response['version'] != null &&
          response['sources'] != null &&
          response['layers'] != null) {
        // Lưu vào cache
        final styleString = jsonEncode(response);
        await _cacheStyle(styleString);
        return styleString;
      }

      // Nếu không phải style map trực tiếp, kiểm tra xem có trong data không
      if (response is Map &&
          response['success'] == true &&
          response['data'] != null) {
        final data = response['data'];
        if (data is Map &&
            data['version'] != null &&
            data['sources'] != null &&
            data['layers'] != null) {
          // Lưu vào cache
          final styleString = jsonEncode(data);
          await _cacheStyle(styleString);
          return styleString;
        }
      }

      // Nếu không tìm thấy style map hợp lệ
      throw ServerException(
        message: 'Không thể lấy được style map: Định dạng không hợp lệ',
      );
    } catch (e) {
      debugPrint('Error fetching VietMap styles: ${e.toString()}');

      // Nếu có lỗi, thử lấy từ cache
      final cachedData = await _getCachedStyle();
      if (cachedData != null) {
        debugPrint('Using cached VietMap style after API error');
        return cachedData;
      }

      throw ServerException(message: 'Lỗi khi lấy style map: ${e.toString()}');
    }
  }

  Future<void> _cacheStyle(String styleString) async {
    try {
      // Lưu vào memory cache
      _cachedStyle = styleString;
      _cacheTimestamp = DateTime.now();

      // Lưu vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'style': styleString,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheData));
      debugPrint('VietMap style cached successfully');
    } catch (e) {
      debugPrint('Error caching VietMap style: $e');
    }
  }

  Future<String?> _getCachedStyle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);

      if (cacheJson != null) {
        final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
          cacheData['timestamp'] as int,
        );
        final now = DateTime.now();

        // Kiểm tra thời gian cache
        if (now.difference(timestamp) < _cacheDuration) {
          return cacheData['style'] as String;
        } else {
          // Cache đã hết hạn
          debugPrint('VietMap style cache expired');
          await prefs.remove(_cacheKey);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error reading VietMap style cache: $e');
      return null;
    }
  }

  // Xóa cache khi cần thiết
  Future<void> clearCache() async {
    try {
      _cachedStyle = null;
      _cacheTimestamp = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      debugPrint('VietMap style cache cleared');
    } catch (e) {
      debugPrint('Error clearing VietMap style cache: $e');
    }
  }
}
