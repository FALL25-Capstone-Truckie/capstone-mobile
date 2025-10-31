import 'package:dio/dio.dart';

/// Interface for HTTP client to avoid dependency on data layer
/// This allows core services to use HTTP functionality without depending on data layer implementation
abstract class IHttpClient {
  /// Make a GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  /// Make a POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  /// Make a PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  /// Make a DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  /// Get the Dio instance (for advanced usage)
  Dio get dio;
}
