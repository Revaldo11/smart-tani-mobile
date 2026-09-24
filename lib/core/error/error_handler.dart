import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

abstract final class ErrorHandler {
  static AppException handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is SocketException) {
      return const AppException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
        type: AppExceptionType.noConnection,
      );
    }

    return const AppException(
      'Terjadi kendala. Silakan coba lagi.',
    );
  }

  static AppException _handleDioException(
    DioException error,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const AppException(
          'Koneksi internet tidak stabil. Silakan coba lagi.',
          type: AppExceptionType.timeout,
        );

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          'Jaringan sedang tidak stabil. Silakan coba beberapa saat lagi.',
          type: AppExceptionType.unstableConnection,
        );

      case DioExceptionType.connectionError:
        return const AppException(
          'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
          type: AppExceptionType.noConnection,
        );

      case DioExceptionType.badResponse:
        return _handleResponse(error);

      case DioExceptionType.cancel:
        return const AppException(
          'Permintaan dibatalkan.',
        );

      case DioExceptionType.badCertificate:
        return const AppException(
          'Koneksi ke server tidak aman.',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const AppException(
            'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
            type: AppExceptionType.noConnection,
          );
        }

        return const AppException(
          'Terjadi kendala jaringan. Silakan coba lagi.',
          type: AppExceptionType.unstableConnection,
        );
      case DioExceptionType.transformTimeout:
        throw UnimplementedError();
    }
  }

  static AppException _handleResponse(
    DioException error,
  ) {
    final statusCode = error.response?.statusCode;
    final message = _getApiMessage(error.response?.data);

    switch (statusCode) {
      case 401:
        return AppException(
          message ?? 'Sesi Anda telah berakhir. Silakan masuk kembali.',
          type: AppExceptionType.unauthorized,
          statusCode: statusCode,
        );

      case 422:
        return AppException(
          message ?? 'Data yang Anda masukkan belum sesuai.',
          type: AppExceptionType.validation,
          statusCode: statusCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return AppException(
          'Server sedang mengalami kendala. Silakan coba beberapa saat lagi.',
          type: AppExceptionType.server,
          statusCode: statusCode,
        );

      default:
        return AppException(
          message ?? 'Terjadi kendala. Silakan coba lagi.',
          statusCode: statusCode,
        );
    }
  }

  static String? _getApiMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}