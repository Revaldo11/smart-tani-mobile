abstract final class ApiConstants {
  static const String baseUrl =
      'http://127.0.0.1:8000/api/v1';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}