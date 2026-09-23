import 'package:dio/dio.dart';
import 'package:smart_tani_mobile/core/constant/api_constant.dart';
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
  }

  late final Dio dio;
}