import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthSessionProvider extends ChangeNotifier {
  AuthSessionProvider(this._repository);

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;

  AuthStatus get status => _status;
  UserModel? get user => _user;

  Future<void> initializeSession() async {
    final hasToken = await _repository.hasToken();

    if (!hasToken) {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _user = await _repository.getCurrentUser();
      _status = AuthStatus.authenticated;
    } on AppException {
      await _repository.clearSession();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (_) {
      await _repository.clearSession();
      _user = null;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  void setAuthenticated(UserModel user) {
    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void setUnauthenticated() {
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } on AppException {
      rethrow;
    } finally {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }
}
