/// API configuration constants
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base API URL for development (Android Emulator)
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  /// WebSocket base URL for development (Android Emulator)
  static const String wsBaseUrl = 'ws://10.0.2.2:8080';

  /// API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String driverInfoEndpoint = '/drivers/me';
  static const String ordersEndpoint = '/orders';
  static const String vehicleEndpoint = '/vehicles';

  /// Request timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// WebSocket configuration
  static const Duration wsReconnectDelay = Duration(seconds: 5);
  static const int wsMaxReconnectAttempts = 5;
}
