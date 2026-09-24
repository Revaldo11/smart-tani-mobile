enum AppExceptionType {
  noConnection,
  unstableConnection,
  timeout,
  server,
  unauthorized,
  validation,
  unknown,
}

class AppException implements Exception {
  const AppException(
    this.message, {
    this.type = AppExceptionType.unknown,
    this.statusCode,
  });

  final String message;
  final AppExceptionType type;
  final int? statusCode;

  bool get isNetworkError =>
      type == AppExceptionType.noConnection ||
      type == AppExceptionType.unstableConnection ||
      type == AppExceptionType.timeout;

  @override
  String toString() => message;
}