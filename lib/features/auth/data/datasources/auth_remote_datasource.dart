import 'package:dio/dio.dart';
import 'package:smart_tani_mobile/features/auth/data/model/auth_response_model.dart';
import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

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
      data: {
        'login': login,
        'password': password,
      },
    );

    final data = response.data?['data'];

    return AuthResponseModel.fromJson(
      data as Map<String, dynamic>,
    );
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/user',
    );

    final data = response.data?['data'];

    return UserModel.fromJson(
      data as Map<String, dynamic>,
    );
  }

  Future<void> logout() async {
    await _dio.post<void>(
      '/auth/logout',
    );
  }
}