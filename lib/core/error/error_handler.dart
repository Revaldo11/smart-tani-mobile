import 'package:dio/dio.dart';

import 'app_exception.dart';

abstract final class ErrorHandler {
  static AppException handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    return const AppException(
      'Terjadi kesalahan. Silakan coba lagi.',
    );
  }

  static AppException _handleDioException(
    DioException error,
  ) {
    final statusCode = error.response?.statusCode;

    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message is String && message.isNotEmpty) {
        return AppException(
          message,
          statusCode: statusCode,
        );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          'Koneksi ke server terlalu lama.',
        );

      case DioExceptionType.connectionError:
        return const AppException(
          'Tidak dapat terhubung ke server.',
        );

      default:
        return AppException(
          'Terjadi kesalahan pada server.',
          statusCode: statusCode,
        );
    }
  }
}