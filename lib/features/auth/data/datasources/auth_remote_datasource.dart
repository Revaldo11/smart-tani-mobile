import 'package:dio/dio.dart';
import 'package:smart_tani_mobile/features/auth/data/model/auth_response_model.dart';
import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

import '../../../../core/error/app_exception.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'terms_accepted': true,
      },
    );

    final data = response.data?['data'];

    return AuthResponseModel.fromJson(
      data as Map<String, dynamic>,
    );
  }

  Future<AuthResponseModel> login({
    required String login,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': login, 'password': password},
    );

    final data = response.data?['data'];

    return AuthResponseModel.fromJson(
      data as Map<String, dynamic>,
    );
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
    );

    final data = response.data?['data'];

    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid /auth/me payload: data must be an object.',
      );
    }

    final isTokenValid = data['is_token_valid'];

    if (isTokenValid is! bool) {
      throw const FormatException(
        'Invalid /auth/me payload: is_token_valid must be a boolean.',
      );
    }

    if (!isTokenValid) {
      throw const AppException(
        'Sesi Anda telah berakhir. Silakan masuk kembali.',
        type: AppExceptionType.unauthorized,
        statusCode: 401,
      );
    }

    final userData = data['user'];

    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }

    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    await _dio.post<void>('/auth/logout');
  }
}
