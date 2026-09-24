import 'package:flutter/material.dart';
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

  // Login
  final loginController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  AppException? _error;

  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _termsAccepted = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  AppException? get error => _error;

  bool get isLoading => _status == AuthStatus.loading;

  bool get loginPasswordVisible => _loginPasswordVisible;
  bool get registerPasswordVisible => _registerPasswordVisible;
  bool get confirmPasswordVisible => _confirmPasswordVisible;

  bool get termsAccepted => _termsAccepted;

  void toggleLoginPassword() {
    _loginPasswordVisible = !_loginPasswordVisible;
    notifyListeners();
  }

  void toggleRegisterPassword() {
    _registerPasswordVisible = !_registerPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  String? validateRequired(
    String? value,
    String field,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi.';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi.';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }

    return null;
  }

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }

    if (value != registerPasswordController.text) {
      return 'Konfirmasi password tidak sama.';
    }

    return null;
  }

  Future<bool> login() async {
    _setLoading();

    try {
      _user = await _repository.login(
        login: loginController.text.trim(),
        password: loginPasswordController.text,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } on AppException catch (error) {
      _setError(error.message);
      return false;
    }
  }

  Future<bool> register() async {
    if (!_termsAccepted) {
      _errorMessage =
          'Anda harus menyetujui Syarat & Ketentuan.';
      notifyListeners();

      return false;
    }

    _setLoading();

    try {
      _user = await _repository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: registerPasswordController.text,
        passwordConfirmation:
            confirmPasswordController.text,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } on AppException catch (error) {
      _setError(error.message);
      return false;
    }
  }

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

  Future<void> logout() async {
    await _repository.logout();

    _user = null;
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;

    clearForm();

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
  }

  void clearForm() {
    loginController.clear();
    loginPasswordController.clear();

    nameController.clear();
    emailController.clear();
    phoneController.clear();
    registerPasswordController.clear();
    confirmPasswordController.clear();

    _termsAccepted = false;
  }

  void _setLoading() {
    _errorMessage = null;
    _status = AuthStatus.loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    loginController.dispose();
    loginPasswordController.dispose();

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}