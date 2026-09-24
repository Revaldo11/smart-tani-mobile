import 'package:flutter/foundation.dart';
import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated, connectionError,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  AppException? _error;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  AppException? get error => _error;

  bool get isLoading => _status == AuthStatus.loading;

  Future<void> initializeSession() async {
  final hasToken = await _repository.hasToken();

  if (!hasToken) {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return;
  }

  try {
    _user = await _repository.getCurrentUser();

    _status = AuthStatus.authenticated;
  } on AppException catch (error) {
    if (error.type == AppExceptionType.unauthorized) {
      await _repository.clearSession();

      _user = null;
      _status = AuthStatus.unauthenticated;
    } else if (error.isNetworkError) {
      _error = error;
      _status = AuthStatus.connectionError;
    } else {
      _error = error;
      _status = AuthStatus.connectionError;
    }
  }

  notifyListeners();
}

  Future<bool> login({
    required String login,
    required String password,
  }) async {
    _setLoading();

    try {
      _user = await _repository.login(
        login: login,
        password: password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } on AppException catch (error) {
      _errorMessage = error.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();

      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading();

    try {
      _user = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } on AppException catch (error) {
      _errorMessage = error.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();

      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    _user = null;
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;

    notifyListeners();
  }

  void _setLoading() {
    _errorMessage = null;
    _status = AuthStatus.loading;
    notifyListeners();
  }
}