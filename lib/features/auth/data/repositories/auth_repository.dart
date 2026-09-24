import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepository {
  AuthRepository({
    required this._remoteDataSource,
    required this._secureStorage,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      await _secureStorage.saveAccessToken(
        response.token,
      );

      return response.user;
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }

  Future<UserModel> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        login: login,
        password: password,
      );

      await _secureStorage.saveAccessToken(
        response.token,
      );

      return response.user;
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      return await _remoteDataSource.getCurrentUser();
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }

  Future<bool> hasToken() async {
    final token = await _secureStorage.getAccessToken();

    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Token lokal tetap harus dibersihkan.
      clearSession();
    } finally {
      await _secureStorage.deleteAccessToken();
    }
  }

  Future<void> clearSession() {
    return _secureStorage.deleteAccessToken();
  }
}