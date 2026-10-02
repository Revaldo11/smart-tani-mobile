import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_tani_mobile/core/constant/api_constant.dart';
import 'package:smart_tani_mobile/core/network/interceptors/auth.dart';
import 'package:smart_tani_mobile/core/storage/secure_storage_service.dart';

class DioClient {
  DioClient({required SecureStorageService secureStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(secureStorage));

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  late final Dio dio;
}
